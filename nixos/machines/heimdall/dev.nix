{ ... }:

{
  # https://pgtune.leopard.in.ua/#/
  # DB Version: 12
  # OS Type: linux
  # DB Type: web
  # Total Memory (RAM): 16 GB
  # CPUs num: 32
  # Connections num: 100
  # Data Storage: ssd

  services.postgresql.settings = {
    max_connections = 100;
    shared_buffers = "4GB";
    effective_cache_size = "12GB";
    maintenance_work_mem = "1GB";
    checkpoint_completion_target = 0.9;
    wal_buffers = "16MB";
    default_statistics_target = 100;
    random_page_cost = 1.1;
    effective_io_concurrency = 200;
    work_mem = "10485kB";
    min_wal_size = "1GB";
    max_wal_size = "4GB";
    max_worker_processes = 32;
    max_parallel_workers_per_gather = 4;
    max_parallel_workers = 32;
    max_parallel_maintenance_workers = 4;
  };
}
