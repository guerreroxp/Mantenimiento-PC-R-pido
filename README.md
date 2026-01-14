# 🛠️ Herramienta de Mantención Windows  
### 💼 EcooEmpresas

Script en **Batch (BAT)** para **Windows 10 y Windows 11**, diseñado para tareas de **mantención, limpieza, respaldo y normalización** de equipos, ideal para **soporte técnico, colegios, laboratorios y empresas**.

---

## 🚀 Características principales

✅ Menú interactivo en consola  
✅ Compatible con **Windows 10 / 11**  
✅ Funciona como **Administrador**  
✅ Genera **logs por usuario y equipo**  
✅ No requiere software adicional  
✅ Seguro y controlado (confirmaciones SI / NO)

---

## 📋 Funcionalidades incluidas

### 🧹 Limpieza
- 🧼 Limpieza de datos de **Google Chrome**
- 🧹 Limpieza de **temporales de Windows**
- 🗂️ Limpieza de carpetas del usuario:
  - Escritorio
  - Documentos
  - Descargas
  - Imágenes
  - Música
  - Videos

---

### 💾 Respaldo de información
- 📁 Respaldo opcional de carpetas del usuario
- 💽 Permite elegir **unidad destino** (C:, D:, USB, etc.)
- 🧾 Estructura automática por:
  - Usuario
  - Equipo
  - Fecha y hora

---

### 📊 Reportes
- 📄 **Reporte de programas instalados**
  - Método 100% CMD (sin PowerShell, sin VBScript)
  - Compatible con entornos restringidos
- 🖥️ Reporte de hardware:
  - RAM
  - Disco
  - Procesador
- 📝 Logs detallados de cada acción ejecutada

---

### 🎨 Personalización y sistema
- 🌞 Restaurar **tema claro** y fondo por defecto
- 📁 Normalizar nombres de carpetas del sistema:
  - Escritorio
  - Documentos
  - Descargas
  - Imágenes
  - Música
  - Videos
  - Papelera de reciclaje
- 🗑️ Limpieza del Explorador de archivos:
  - Archivos recientes
  - Accesos rápidos
  - Ubicaciones de red

---

### 🏢 Imagen corporativa
- 🖼️ Aplicar fondo de pantalla corporativo
- 👤 Aplicar imagen de usuario
- 🔒 Preparado para pantalla de inicio (lock screen)
- 📌 Archivos cargados desde la carpeta del script

---

## 📁 Estructura del proyecto

```text
📦 mantenimiento-windows
 ┣ 📜 mantenimiento.bat
 ┣ 📁 Reportes
 ┃ ┣ 📄 logs.txt
 ┃ ┣ 📄 Programas_Instalados_*.txt
 ┃ ┗ 📄 Hardware_*.txt
 ┣ 🖼️ 1.jpg   (pantalla de inicio)
 ┣ 🖼️ 2.jpg   (fondo de pantalla)
 ┣ 🖼️ 3.jpg   (imagen de usuario)
 ┗ 📄 README.md
