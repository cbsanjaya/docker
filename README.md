# docker

Docker Compose untuk menjalankan aplikasi laravel dengan database Mysql dan Redis Memory Cache.

## Menjalankan dan Update Container Development

jalankan docker: `docker-compose up -d`.

## Menjalankan dan Update Container Production

jalankan docker: `docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d`.

## Backup dan Restore

backup `docker-compose exec db backup` dan restore dengan `docker-compose exec restore <nama-file-backup>`