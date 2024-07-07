# Activar entorno virtual de Python
Write-Host "Activando entorno virtual"
py -3 -m venv .venv
.\.venv\Scripts\Activate.ps1

# Actualizar pip
Write-Host "Actualizando pip"
python -m pip install --upgrade pip

# Instalar requerimientos
Write-Host "Instalando requirements"
pip install -r "requirements.txt"

# Inicializar reflex
Write-Host "Inicializando reflex"
reflex init

# Exportar solo el frontend de reflex y capturar la salida
Write-Host "Exportando reflex frontend"
reflex export --frontend-only 2>&1
Write-Host $exportOutput

# # Listar archivos en el directorio actual para depuración
# Write-Host "Listando archivos en el directorio actual después de reflex export"
# Get-ChildItem

# # Listar archivos de manera recursiva para depuración
# Write-Host "Listando archivos de manera recursiva después de reflex export"
# Get-ChildItem -Recurse

# # Verificar si frontend.zip existe en cualquier parte del proyecto
# Write-Host "Verificando la existencia de frontend.zip en cualquier parte del proyecto"
# $zipFile = Get-ChildItem -Recurse -Filter "frontend.zip" | Select-Object -First 1
# if ($zipFile) {
#     Write-Host "frontend.zip encontrado en: $($zipFile.FullName)"
# } else {
#     Write-Host "frontend.zip no encontrado, abortando"
#     exit 1
# }

# Eliminar el directorio public si existe
Write-Host "Removiendo public directory"
Remove-Item -Recurse -Force public

# Crear un nuevo directorio public
Write-Host "Creando public directory"
New-Item -ItemType Directory -Path public

# Extraer el contenido de frontend.zip a public
Write-Host "Extrayendo archivos de frontend.zip a public"
Expand-Archive -Path $zipFile.FullName -DestinationPath public

# Eliminar el archivo frontend.zip
Write-Host "Removiendo frontend.zip"
Remove-Item -Force $zipFile.FullName

# Añadir cambios a git
Write-Host "Adding changes to git"
git add .

# Hacer commit de los cambios
Write-Host "Committing changes"
git commit -m "Adjust workflow for Windows environment"

# Hacer push de los cambios
Write-Host "Pushing changes"
git push
