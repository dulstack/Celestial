#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>
#include <errno.h>
#include <sys/stat.h>
#define ASSERT(x, err)\
	if((x) < 0){\
		error_message=err;\
		goto error;\
	}

const char script_contents[] =
"[Theme]\n"
"name=oxygen";

static inline int change_conf(){
	FILE *fp = fopen("plasmarc", "w");
	if(!fp){
		fprintf(stderr, "Failed to open \"plasmarc\":"
				" %s\n", strerror(errno));
		return -1;
	}
	fwrite(script_contents, sizeof(script_contents) - 1, 1, fp);
	fclose(fp);
	return 0;
}
void deinit(struct dirent **userdirs, char** const argv){
	if(userdirs)free(userdirs);
	//This script is executed only once
	remove("/usr/lib/systemd/system/set_oxygen_theme.service");
	//Remove itself	
	remove(argv[0]);
}
int main(int argc, char** argv){
	struct dirent **userdirs = NULL;
	int count;
	const char* error_message = NULL;
	//Add the script for every user
	ASSERT(chdir("/home/"),
		     "Failed to change current directory to \"/home/\": ");
	ASSERT(count = scandir("/home/", &userdirs, NULL, alphasort), 
		     "Failed to scan directory \"home\": ");
	//Skip the directories "." and ".." which must be the first two 
	for(int i = 2; i < count; i++){
		ASSERT(chdir(userdirs[i]->d_name),
		     "Failed to change current directory: ");
		ASSERT(chdir(".config/"),
		     "Failed to change current directory to \".config/\": ");
		int res = change_conf();
		free(userdirs[i]);
		//The file "plasmarc" is owned by root, we need to change it
		struct stat statbuf;
		//Get the st_uid and st_gid
		ASSERT(stat(".", &statbuf), "stat for user directory failed: ");

		ASSERT(chown("plasmarc", statbuf.st_uid, statbuf.st_gid),
		 "Failed to change the ownership of the file \"plasmarc\": ");
		chdir("/home/");
		if(res)goto error;
	}
	deinit(userdirs, argv);
	return 0;

	error:
	 fprintf(stderr, "%s%s\n", error_message, strerror(errno));
	 deinit(userdirs, argv);
	 return 1;

}
