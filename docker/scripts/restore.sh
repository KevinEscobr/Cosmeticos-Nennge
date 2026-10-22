#!/bin/bash

# ==============================================================================
# MYSQL DOCKER RESTORE SCRIPT PARA DOBLE ENCANTO
# ==============================================================================

set -euo pipefail

CONTAINER_NAME="cosmeticos-backend-db"
DB_USER="cosmeticos_user"
DB_PASS="cosmeticos_secret_password"
DB_NAME="cosmeticos_db"

if [ -z "${1:-}" ]; then
    echo "Uso: $0 <archivo_respaldo.sql.gz>" >&2
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "${BACKUP_FILE}" ]; then
    echo "ERROR: El archivo no existe: ${BACKUP_FILE}" >&2
    exit 1
fi

echo "Iniciando restauración de ${BACKUP_FILE} en ${DB_NAME}..."

gunzip -c "${BACKUP_FILE}" | docker exec -i "${CONTAINER_NAME}" mysql -u "${DB_USER}" -p"${DB_PASS}" "${DB_NAME}"

echo "Restauración completada con éxito."
