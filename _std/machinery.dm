#define PROCESSING_FULL      1
#define PROCESSING_HALF      2

// Uncomment and adjust PROCESSING_MAX_IN_USE as needed
//#define PROCESSING_QUARTER   3
//#define PROCESSING_EIGHTH    4
//#define PROCESSING_SIXTEENTH 5


#define PROCESSING_MAX_IN_USE PROCESSING_HALF

var/global/list/processing_machines = generate_machinery_processing_buckets()

/proc/generate_machinery_processing_buckets()
	. = new /list(PROCESSING_MAX_IN_USE)
	for(var/i in 1 to PROCESSING_MAX_IN_USE)
		.[i] = new /list(1<<(i-1)) // 1 list for index 1, 2 for 2, 4 for 3, 8 for 4, 16 for 5
		for (var/j in 1 to length(.[i]))
			.[i][j] = list()

#define STOP_PROCESSING(target) do {\
	if (target.current_processing_tier) {\
		processing_machines[target.current_processing_tier][(target.processing_bucket%(1<<(target.current_processing_tier-1)))+1] -= target;\
		target.current_processing_tier = null;\
	};\
	} while (FALSE)

#define START_PROCESSING(target, priority) do {\
	if (target.current_processing_tier) { \
		STOP_PROCESSING(target);\
	};\
	target.current_processing_tier = priority;\
	processing_machines[priority][(target.processing_bucket%(1<<(priority-1)))+1] += target;\
	} while (FALSE)
