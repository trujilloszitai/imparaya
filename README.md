# ImparaYa
# Sistema de gestión y reserva de clases/mentorías

## **📋 Tabla de Contenidos**


  - [**Alcance del sistema**](#alcance-del-sistema)
  - [**Modelos del sistema**](#modelos-del-sistema)
  - [**Requisitos Previos**](#requisitos-previos)
  - [**Instalación y Configuración (Devcontainer)**](#instalación-y-configuración-devcontainer)
  - [**Configuración de Credenciales y Variables de Entorno**](#configuración-de-credenciales-y-variables-de-entorno)
    - [**1. Credenciales Encriptadas (**`credentials.yml.enc`**)**](#1-credenciales-encriptadas-credentialsymlenc)
    - [**2. Variables de Entorno (**`.env`**)**](#2-variables-de-entorno-env)
  - [**Integración con Mercado Pago**](#integración-con-mercado-pago)
  - [**Despliegue Local con Ngrok (Webhooks)**](#despliegue-local-con-ngrok-webhooks)
  - [**Cómo Probar el Sistema**](#cómo-probar-el-sistema)
    - [**1. Iniciar el Servidor**](#1-iniciar-el-servidor)
    - [**2. Realizar un Pago de Prueba**](#2-realizar-un-pago-de-prueba)
    - [**3. Verificar el Webhook**](#3-verificar-el-webhook)

## Alcance del sistema

1. Reserva de clases bajo demanda con mentores según los tópicos, horarios y precios en los que el estudiante esté interesado.

2. Proporcionar una pasarela de pagos en línea por medio de Mercado Pago “Checkout API” para realizar el abono de las clases.

3. Gestión de disponibilidades horarias, estudiantes y clases programadas para cada mentor.

4. Registro histórico de clases, tanto para mentores como estudiantes.

## Modelos del sistema

**User** (usuario)

| Atributo  | Tipo de dato                      |
| --------- | --------------------------------- |
| firstName | string                            |
| lastName  | string                            |
| email     | string                            |
| password  | string                            |
| phone     | string                            |
| biography | text                              |
| role      | integer { student: 0, mentor: 1 } |

Relaciones:
- hasMany: Availability (en caso de ser Mentor)
- hasMany: Booking (en caso de ser Student)

**Category** (categoría)

| Atributo | Tipo de dato |
| -------- | ------------ |
| name     | string       |
| color    | string       |

Relaciones:
- hasMany: Availability

**Availability** (disponibilidad horaria)

| Atributo       | Tipo de dato        |
| -------------- | ------------------- |
| description    | text                |
| day_of_week    | int (0-6)           |
| starts_at      | time                |
| ends_at        | time                |
| price_per_hour | decimal             |
| capacity       | int (default: null) |

Relaciones:
- belongsTo: Mentor
- belongsTo: Category

**Booking** (reserva)

| Atributo      | Tipo de dato                                              |
| ------------- | --------------------------------------------------------- |
| status        | int { pendiente: 0, pago: 1, cancelado: 2, rechazado: 3 } |
| preference_id | string                                                    |
| starts_at     | datetime                                                  |
| ends_at       | datetime                                                  |
| price         | decimal                                                   |

Relaciones:
- belongsTo: Student
- belongsTo: Availability
- hasMany: Payment

**Payment** (Pago)
| Atributo            | Tipo de dato |
| ------------------- | ------------ |
| external_reference  | string       |
| mp_payment_id       | string       |
| transaction_amount  | decimal      |
| net_received_amount | decimal      |
| payer_email         | string       |
| payment_method_id   | string       |
| status              | string       |
| status_detail       | string       |

Relaciones:
- belongsTo: Booking

## **Requisitos Previos**

Antes de comenzar con el set-up del proyecto, asegúrate de tener instalado:

- **[Docker Desktop](https://docs.docker.com/desktop/)** (además de Docker Engine corriendo).

- **[Visual Studio Code](https://code.visualstudio.com/)**.

- [Extensión ](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)**[Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)** para VS Code.

- Una cuenta de desarrollador en[ Mercado Pago Developers](https://www.mercadopago.com.ar/developers/en).

- Una cuenta en[ Ngrok](https://ngrok.com/).


## **Instalación y Configuración (Devcontainer)**


**Clonar el repositorio:**
```bash
$ git clone https://github.com/trujilloszitai/imparaya.git

$ cd imparaya
```

1. **Abrir en el Contenedor:**

- Abre la carpeta del proyecto en VS Code.

- Verás una notificación en la esquina inferior derecha: *"Reopen in Container"*. Haz clic en ella.

- *Alternativa:* Presiona `F1`, escribe `Dev Containers: Reopen in Container`.

- VS Code construirá la imagen (esto puede tardar unos minutos la primera vez) e instalará automáticamente las gemas de Ruby y las extensiones necesarias.


## **Configuración de Credenciales y Variables de Entorno**

Este proyecto utiliza **Rails Encrypted Credentials** para manejar claves sensibles (API Keys de Mercado Pago) y un archivo `.env` para la configuración dinámica del host (Ngrok).

### **1. Credenciales Encriptadas (**`credentials.yml.enc`**)**

Las claves de API de Mercado Pago no se guardan en texto plano. Para editarlas o añadirlas, ejecuta el siguiente comando en la terminal (asegurate de eliminar el archivo config/credentials.yml.enc predeterminado, ya que no contarás con el archivo master.key necesario para desencriptarlo):

`rm ./config/credentials.yml.enc && EDITOR="code --wait" rails credentials:edit`

Esto creará un nuevo archivo config/master.key y abrirá el archivo desencriptado en VS Code. Asegúrate de tener la siguiente estructura con tus credenciales de prueba:

```yml
#config/credentials.yml.enc
mercadopago:
    public_key: TEST-tu-public-key-de-mp
    access_token: TEST-tu-access-token-de-mp
```

### **2. Variables de Entorno (**`.env`**)**

Crea un archivo `.env` en la raíz del proyecto. Este se usará únicamente para definir la URL pública generada por Ngrok, lo cual es necesario para permitir las peticiones externas a la aplicación (configuración de hosts de Rails).

Actualiza esta variable cada vez que obtengas una nueva URL de Ngrok
```bash
#.env
WEBHOOK_URL=https://tu-id-aleatorio.ngrok-free.app
```


**Base de Datos (SQLite3)**

El proyecto utiliza **SQLite3**, por lo que la base de datos es un archivo local dentro del contenedor y no requiere un servicio de Docker externo.

1. **Inicializar la base de datos:** Dentro de la terminal del Devcontainer, ejecuta: \
```bash
$ bin/rails db:create

$ bin/rails db:migrate
```

2. **Cargar datos de prueba (Seeds):** Para poblar la base de datos de ejemplo: \
```bash
$ bin/rails db:seed
```
La base de datos se guardará habitualmente en `storage/development.sqlite3` o `db/development.sqlite3`.


## **Integración con Mercado Pago**

El sistema utiliza **Checkout API**. El flujo funciona de la siguiente manera:

1. El estudiante reserva una clase y hace click en "Pagar".

2. El backend genera una preferencia de pago y redirige al usuario al checkout seguro de Mercado Pago.

3. Al finalizar (exitoso, fallido o pendiente), MP redirige al usuario de vuelta a nuestra app (`back_urls`).

4. **Importante:** MP envía una notificación asíncrona (Webhook) a nuestro servidor para confirmar el estado real del pago y actualizar la reserva en la base de datos.

> [!WARNING]
> Sí configuras tu propia integración de Mercado Pago, asegúrate de utilizar las credenciales de una [ cuenta de vendedor de prueba ](https://www.mercadopago.com.ar/developers/es/docs/your-integrations/test/accounts) y no las de tu cuenta real de Mercado Pago.
> Consulta [ Checkout API (vía Payments) ](https://www.mercadopago.com.ar/developers/es/docs/checkout-api-payments/overview) para más detalles.


## **Despliegue Local con Ngrok (Webhooks)**

Para que Mercado Pago pueda notificar a tu entorno local (`localhost`) sobre el estado de los pagos, necesitas un túnel seguro.

**Iniciar Ngrok:** En una terminal de tu máquina local (fuera del contenedor), ejecuta:

```bash
$ ngrok http 3000
```

Nota: Si tu Rails corre en otro puerto, ajusta el 3000.

1. **Copiar la URL de Ngrok:** Copia la dirección HTTPS generada (ej: `https://a1b2-c3d4.ngrok-free.app`).

2. **Configurar Webhook en Mercado Pago:**

- Ve a [Tus Integraciones](https://mercadopago.com.ar/developers/panel/app).

- En la sección **Notificaciones Webhooks**, selecciona "Modo de Producción" (o Pruebas si aplica a tu versión de panel).

- Pega tu URL de Ngrok (o la URL pública que estés usando) agregando la ruta de tu controlador, por ejemplo: `https://tu-url-ngrok.app/webhooks/mercadopago`

- Selecciona los eventos: `payment`.


## **Cómo Probar el Sistema**

### **1. Iniciar el Servidor**

Dentro de la terminal del Devcontainer:

```bash
bin/rails s -b 0.0.0.0
```
o también puedes usar el script de inicio rápido:

```bash
bin/dev
```

Abre tu navegador en `http://localhost:3000`.

### **2. Realizar un Pago de Prueba**

**ADVERTENCIA:** No uses tus tarjetas reales ni cuentas personales de Mercado Pago. Usa siempre credenciales de prueba.

1. Loguéate como un **Estudiante**.

2. Reserva una clase.

3. En el Checkout de Mercado Pago, usa las **Tarjetas de Prueba**:

- Ver [ Tarjetas de prueba disponibles ](https://mercadopago.com.ar/developers/es/docs/checkout-api/integration-test/test-cards).

- Usa un email diferente al de tu cuenta de desarrollador (puedes usar `test_user_123456@testuser.com`).

- Si durante el checkout Mercado Pago te solicita un código de verificación, dicho código serán los últimos 6 digitos del ID del usuario con el que hayas iniciado sesión en Mercado Pago. Para esto es obligatorio que tengas una cuenta de desarrollador para poder obtener dicho ID.

### **3. Verificar el Webhook**

- Observa la terminal donde corre Rails. Deberías ver llegar una petición `POST` a tu endpoint de webhooks.

- Observa la terminal de Ngrok (o en el inspector de Ngrok en [localhost:4040](http://localhost:4040)) para confirmar el status `200 OK`.
