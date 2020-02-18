#define PROCESSING_FULL      1
#define PROCESSING_HALF      2
#define PROCESSING_QUARTER   3
#define PROCESSING_EIGHTH    4
#define PROCESSING_SIXTEENTH 5


/proc/generate_machinery_processing_buckets()
	. = new /list(5)
	.[1] = list() // Taking a shortcut here because the full processing level is unrolled in the controller
	for(var/i in 2 to 5)
		.[i] = new /list(1<<(i-1)) // 2 for 2, 4 for 3, 8 for 4, 16 for 5
		for (var/j in 1 to length(.[i]))
			.[i][j] = list()


#define START_PROCESSING(target, priority) do { (priority == PROCESSING_FULL ? bucketmachines[PROCESSING_FULL].Add(target) : bucketmachines[priority][(target.processing_bucket%(1<<(priority-1)))].Add(target)) } while (false)
#define STOP_PROCESSING(target) do { (target.current_processing_tier ? (target.current_processing_tier == PROCESSING_FULL ? bucketmachines[PROCESSING_FULL].Remove(target) : (bucketmachines[current_processing_tier][(target.processing_bucket%(1<<(current_processing_tier-1)))].Remove(target)) ) : null) } while (false)
