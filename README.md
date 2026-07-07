# Auditoria de Seguridad Local (Endpoint) en PowerShell

Este script automatizado en PowerShell realiza un analisis rapido del estado de seguridad en entornos Windows (Endpoints). Esta diseñado para ayudar a administradores de sistemas y analistas de ciberseguridad a verificar configuraciones criticas, mitigar riesgos de manera agil y registrar evidencias de cumplimiento.

## Caracteristicas del Analisis
* **Verificacion de Antivirus:** Revisa el estado de Windows Defender y que la proteccion en tiempo real se encuentre activa.
* **Auditoria de Firewall:** Evalua el estado de los tres perfiles de red esenciales (Dominio, Privado y Publico).
* **Control de Identidades y Privilegios:** Lista explicitamente las cuentas locales que pertenecen al grupo de *Administradores* para mitigar riesgos de escalada de privilegios o cuentas clonadas.
* **Escaneo de Conexiones:** Muestra los primeros puertos internos activos y conexiones TCP para identificar anomalias en la red.
* **Gestion de Parches (Windows Update):** Detecta si existen parches criticos de seguridad pendientes en el sistema operativo.
* **Acciones de Mitigacion:** Proporciona de forma dinamica en pantalla los comandos recomendados en verde (`winget` y `PSWindowsUpdate`) si se requiere parchar el equipo.
* **Generacion de Reporte Físico:** Exporta en tiempo real todo el output de la auditoria a un archivo de texto local (`Reporte_Seguridad_Local.txt`) como registro de evidencia.

---

## Como Ejecutar el Script

### Opcion 1: Ejecucion Directa (Recomendado)
Para correr el analisis sin escribir comandos largos, haz clic derecho sobre el archivo ejecutable **`Ejecutar_Auditoria.bat`** y selecciona **Ejecutar como administrador**.

### Opcion 2: Desde la Terminal de PowerShell
1. Abre PowerShell como Administrador.
2. Navega hasta la carpeta del proyecto.
3. Ejecuta el siguiente comando para evadir temporalmente las restricciones de ejecucion:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\Auditoria_Seguridad.ps1
Formato de Salida (Logs)
Al finalizar, el script guarda de forma automatica un reporte estructurado en la raiz del proyecto:

Archivo: Reporte_Seguridad_Local.txt

Contenido: Incluye marcas de tiempo, estado detallado de los componentes de seguridad revisados y comandos de mitigacion sugeridos.

Solucion a Problemas Frecuentes (Troubleshooting)
1. Error de Politicas de Ejecucion (Execution_Policies)
Problema: Windows bloquea el script mostrando un mensaje en rojo indicando que la ejecucion de scripts esta deshabilitada en el sistema.

Solucion: Abre PowerShell como Administrador y desbloquea la sesion actual ejecutando: Set-ExecutionPolicy Bypass -Scope Process -Force

2. Error con Espacios en las Rutas de Acceso
Problema: La terminal arroja un error indicando que un termino o carpeta no se reconoce como un comando valido.

Solucion: Esto ocurre porque PowerShell rompe la lectura al encontrar espacios en los nombres de las carpetas. Asegurate de encerrar siempre la ruta completa entre comillas e iniciarla con el operador de ejecucion &: & "C:\Ruta Con Espacios\Auditoria_Seguridad.ps1"

3. Error de Caracteres o Terminador (ParserError / TerminatorExpected)
Problema: Mensajes que indican que "Falta la cadena en el terminator" o "Falta la llave de cierre".

Solucion: Ocurre debido a que las tildes o caracteres especiales rompen la codificacion nativa de Windows PowerShell (v5.1). Este script ha sido limpiado por completo de acentos para evitar este conflicto. Asegurate de guardar el archivo .ps1 usando la codificacion UTF-8 desde el Bloc de Notas.

4. Error por falta de Permisos de Administrador
Problema: El modulo de Windows Update, la creacion de reportes o las consultas de red devuelven errores de acceso denegado.

Solucion: El script requiere privilegios elevados para interactuar con los componentes de seguridad del sistema y escribir logs. Asegurate de que la terminal o el lanzador .bat se ejecuten explicitamente en modo de Administrador.
