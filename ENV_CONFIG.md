# Configuración de Variables de Entorno

Este proyecto utiliza variables de entorno para gestionar configuraciones sensibles y específicas del entorno.

## Configuración Inicial

1. **Copiar el archivo de ejemplo:**
   ```bash
   cp .env.example .env
   ```

2. **Configurar las variables:**
   Edita el archivo `.env` con tus valores específicos.

## Variables Disponibles

### API Configuration

- `BASE_URL`: URL base principal de la API
  - Producción: `https://app.formarte.co/api`
  - Desarrollo: `https://dev-mongo.plataformapodium.com/api`
  - Local: `https://105kt18s-3000.use2.devtunnels.ms/api`

- `BASE_URL_2`: URL base secundaria de la API
  - Producción: `https://api.formarte.co/api`
  - Desarrollo: `https://dev-mongo.plataformapodium.com/api`

- `AUTH_BASE_URL`: URL base para autenticación
  - Producción: `https://app.formarte.co`

- `AUTH_SAF_URL`: URL SAF para autenticación
  - Producción: `https://stage-api.plataformapodium.com/api`

### App Configuration

- `APP_NAME`: Nombre de la aplicación (por defecto: "Lexxi")
- `APP_VERSION`: Versión de la aplicación (por defecto: "1.0.39")

### Environment

- `ENVIRONMENT`: Entorno de ejecución
  - Valores posibles: `production`, `development`, `staging`
  - Por defecto: `production`

## Uso en el Código

### Importar la configuración

```dart
import 'package:lexxi/config/env_config.dart';
```

### Acceder a las variables

```dart
// URL base de la API
String apiUrl = EnvConfig.baseUrl;
String apiUrl2 = EnvConfig.baseUrl2;

// URLs de autenticación
String authUrl = EnvConfig.authBaseUrl;
String authSafUrl = EnvConfig.authSafUrl;

// Información de la app
String appName = EnvConfig.appName;
String version = EnvConfig.appVersion;

// Verificar el entorno
if (EnvConfig.isDevelopment) {
  print('Estamos en desarrollo');
}

if (EnvConfig.isProduction) {
  print('Estamos en producción');
}

// Obtener variable personalizada
String? customVar = EnvConfig.get('CUSTOM_VAR', fallback: 'valor_por_defecto');
```

### Imprimir configuración actual (debug)

```dart
EnvConfig.printConfig();
```

## Archivos Importantes

- `.env` - Archivo con tus variables de entorno (NO se sube a Git)
- `.env.example` - Plantilla con las variables disponibles (SÍ se sube a Git)
- `lib/config/env_config.dart` - Clase para acceder a las variables

## Seguridad

⚠️ **IMPORTANTE:**
- El archivo `.env` está excluido del control de versiones (`.gitignore`)
- Nunca subas archivos `.env` con datos sensibles a repositorios públicos
- Usa `.env.example` como plantilla para que otros desarrolladores sepan qué variables necesitan configurar

## Diferentes Entornos

### Desarrollo Local

```env
BASE_URL=https://105kt18s-3000.use2.devtunnels.ms/api
BASE_URL_2=https://105kt18s-3000.use2.devtunnels.ms/api
ENVIRONMENT=development
```

### Staging

```env
BASE_URL=https://dev-mongo.plataformapodium.com/api
BASE_URL_2=https://dev-mongo.plataformapodium.com/api
ENVIRONMENT=staging
```

### Producción

```env
BASE_URL=https://app.formarte.co/api
BASE_URL_2=https://api.formarte.co/api
ENVIRONMENT=production
```

## Actualización de Dependencias

Si es la primera vez que usas el proyecto, ejecuta:

```bash
flutter pub get
```

## Troubleshooting

### Error: "Unable to load asset: .env"

**Solución:** Verifica que:
1. El archivo `.env` existe en la raíz del proyecto
2. El archivo está listado en `pubspec.yaml` bajo `assets`
3. Has ejecutado `flutter pub get` después de modificar `pubspec.yaml`

### Las variables no se actualizan

**Solución:**
1. Detén la aplicación completamente
2. Ejecuta `flutter clean`
3. Vuelve a ejecutar `flutter pub get`
4. Inicia la aplicación nuevamente
