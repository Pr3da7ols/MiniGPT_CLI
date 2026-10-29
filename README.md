# MiniGPT CLI

Tu asistente de IA para trabajar con proyectos desde la terminal de Termux. MiniGPT ejecuta las herramientas en el dispositivo y envía las conversaciones desde un servidor local hasta tu relay y tu IA:

```text
MiniGPT CLI → servidor local en Termux → tu relay → tu IA
```

El instalador configura el CLI. Para obtener respuestas de tu IA, también necesitas configurar la dirección y el token de tu relay. No publiques claves ni archivos `.env` en GitHub.

## Instalar en Termux

Sube el contenido de este proyecto a un repositorio de GitHub llamado `MiniGPT_CLI`. Antes de publicarlo, abre `install.sh` y cambia `OWNER="OWNER"` por tu nombre de usuario de GitHub.

En Termux, ejecuta este comando y reemplaza `TU_USUARIO` por el mismo nombre:

```bash
curl -fsSL https://raw.githubusercontent.com/TU_USUARIO/MiniGPT_CLI/main/install.sh | bash
```

Si Termux no reconoce `curl`, instálalo primero:

```bash
pkg update -y && pkg install -y curl
```

El instalador instala Git y Python, descarga el repositorio y crea el entorno de MiniGPT. No contiene tu token del relay ni tu clave de IA.

## Configurar tu IA

Después de instalar, abre el archivo de configuración:

```bash
nano ~/.mini_gpt/.env
```

Completa al menos estos valores con los datos de tu relay:

```dotenv
MINIGPT_RELAY_URL=https://TU_DOMINIO/relay
MINIGPT_RELAY_TOKEN=TU_TOKEN_DEL_RELAY
```

`MINIGPT_API_KEY` es la clave local que el CLI usa para hablar con el servidor de Termux; no es necesariamente la clave de tu proveedor de IA. Puedes dejarla vacía para que MiniGPT cree y comparta una clave local automáticamente. Guarda el archivo y cierra `nano` con `Ctrl+O`, `Enter` y `Ctrl+X`.

El relay debe estar activo y configurado para enviar las solicitudes a tu IA. `apiOpenAI.ts` no se instala desde este repositorio: debe estar desplegado donde corre tu relay. No pongas secretos dentro del README ni los subas a GitHub.

## Iniciar

En cada sesión de Termux, activa primero el entorno instalado:

```bash
source ~/.venvs/minigpt/bin/activate
```

En una sesión, deja el servidor local funcionando:

```bash
mini-gpt-server
```

En otra sesión, activa el entorno también y comprueba la conexión:

```bash
source ~/.venvs/minigpt/bin/activate
mini-gpt --doctor
mini-gpt
```

MiniGPT puede leer y modificar archivos y ejecutar comandos en el dispositivo. Para pedir aprobación antes de usar herramientas, inicia con:

```bash
source ~/.venvs/minigpt/bin/activate
mini-gpt --approval-mode ask
```

## Ejemplos

```bash
mini-gpt "explícame este proyecto"
mini-gpt -p "corrige el error" --cwd ~/mi-proyecto
cat error.log | mini-gpt -p "analiza este error"
mini-gpt --plan "propón una forma de probar este código"
mini-gpt --no-tools "explica qué significa este mensaje"
mini-gpt --help
```

En el modo interactivo puedes usar `/help`, `/tools`, `/plan`, `/save`, `/load`, `/compact`, `/undo` y `/exit`. Las sesiones se guardan en `~/.mini_gpt/sessions/`.

## Actualizar

Vuelve a ejecutar el mismo comando de instalación. Si el repositorio ya está clonado, el instalador lo actualiza y reinstala MiniGPT.

## Solución de problemas

- **No conecta con el relay:** revisa `MINIGPT_RELAY_URL`, `MINIGPT_RELAY_TOKEN` y que el relay esté en línea.
- **No aparece `mini-gpt`:** cierra y vuelve a abrir Termux, o activa el entorno con `source ~/.venvs/minigpt/bin/activate`.
- **Error al instalar desde GitHub:** comprueba que el repositorio sea público, que el nombre sea `MiniGPT_CLI`, que la rama sea `main` y que `OWNER` en `install.sh` coincida con tu usuario.
- **No compartas** `~/.mini_gpt/.env`, `~/.mini_gpt/api_key` ni tu token del relay.

## Archivos principales

- `mini_gpt_cli.py`: CLI y agente que usa las herramientas locales.
- `mini_gpt.py`: lanzador de Python.
- `mini_gpt/`: servidor local compatible con OpenAI, configuración de relay y pruebas.
- `install.sh`: instalador para Termux.

Consulta [mini_gpt/README.md](mini_gpt/README.md) para más detalles sobre el servidor y el formato que debe aceptar el relay.
