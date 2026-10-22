#!/bin/bash

# ==============================================================================
# MYSQL DOCKER BACKUP SCRIPT PARA DOBLE ENCANTO
# ==============================================================================

set -euo pipefail

CONTAINER_NAME="cosmeticos-backend-db"
DB_USER="cosmeticos_user"
DB_PASS="cosmeticos_secret_password"
DB_NAME="cosmeticos_db"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/../backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${DB_NAME}_${DATE}.sql.gz"

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Iniciando respaldo de la base de datos ${DB_NAME}..."

mkdir -p "${BACKUP_DIR}"

if ! docker exec "${CONTAINER_NAME}" mysqldump -u "${DB_USER}" -p"${DB_PASS}" --single-transaction --quick --routines "${DB_NAME}" | gzip > "${BACKUP_FILE}"; then
    echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] ERROR: El respaldo falló. Verifica si el contenedor ${CONTAINER_NAME} está en ejecución." >&2
    exit 1
fi

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Respaldo generado exitosamente en: ${BACKUP_FILE}"

# Limpieza: Mantener los respaldos de los últimos 14 días
echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Eliminando respaldos de más de 14 días..."
find "${BACKUP_DIR}" -name "backup_${DB_NAME}_*.sql.gz" -mtime +14 -type f -delete || true

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Limpieza de respaldos finalizada."
