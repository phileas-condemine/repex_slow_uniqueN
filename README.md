# repex_slow_uniqueN
Parallelization when grouping and computing uniqueN is having a surprising behavior

When I use parallelization for sum task, it works as expected : 

![perf_par_sum](perf_DT_basic_sum_grouping_parallelized.png)

But when I use uniqueN, the parallelization makes it worse.

![perf_par_uniqueN](perf_DT_uniqueN_grouping_parallelized.png)
