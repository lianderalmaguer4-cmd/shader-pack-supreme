# 📥 GUÍA DE INSTALACIÓN - SHADER PACK SUPREME

## ¡Hola! Esta es la guía completa paso a paso

---

## ✅ PASO 1: Descargar Fabric Loader

### Instrucciones:
1. Ve a: **https://fabricmc.net/**
2. Haz clic en **"Download Installer"**
3. Ejecuta el archivo `.exe` (Windows) o `.jar` (Mac/Linux)
4. Selecciona la versión: **1.21.11**
5. Selecciona tu carpeta de Minecraft
6. Haz clic en **"Install"**

### 📍 Ubicación de carpeta Minecraft:
- **Windows**: `%AppData%\.minecraft`
- **Mac**: `~/Library/Application Support/minecraft`
- **Linux**: `~/.minecraft`

---

## ✅ PASO 2: Descargar Mods Requeridos

### Necesitas descargar:
1. **Iris Shaders 1.10.7**
   - Sitio: https://irisshaders.net/
   - Selecciona: Minecraft 1.21.1 + Fabric
   - Descarga el archivo `.jar`

2. **Sodium 0.8.7**
   - Sitio: https://modrinth.com/mod/sodium
   - Selecciona: Minecraft 1.21.1 + Fabric
   - Descarga el archivo `.jar`

### 📂 Colocar archivos:
1. Abre la carpeta: `.minecraft/mods`
2. Copia aquí:
   - `iris-1.10.7+1.21.1.jar`
   - `sodium-fabric-0.8.7+mc1.21.1.jar`

---

## ✅ PASO 3: Instalar Shader Pack SUPREME

### Instrucciones:
1. Descarga `ShaderPackSUPREME.zip` desde **Releases**

2. **NO descomprimas** el archivo

3. Navega a: `.minecraft/shaderpacks`
   - Si la carpeta no existe, **créala manualmente**

4. **Copia el archivo ZIP completo** a esta carpeta:
   ```
   .minecraft/
   └── shaderpacks/
       └── ShaderPackSUPREME.zip ← Copia aquí
   ```

5. ✅ **¡Listo!**

---

## ✅ PASO 4: Activar el Shader Pack

### En el Juego:
1. Abre **Minecraft**
2. Inicia el juego
3. En el menú principal, ve a: **Opciones**
4. Selecciona: **Configuración de Video**
5. Busca: **Shaders** (o similar)
6. Abre: **Carpeta de Shaders**
7. Verifica que `ShaderPackSUPREME.zip` esté ahí
8. Vuelve a Configuración de Video
9. En la lista de shaders, selecciona: **SHADER PACK SUPREME**
10. Aplica cambios
11. ¡**¡¡Disfruta los gráficos increíbles!!!**

---

## ⚙️ CONFIGURACIÓN INICIAL RECOMENDADA

### Paso 1: Elegir Perfil
En **Configuración de Video → Shader Options**:

- **Si tienes RTX 3080/3090**: Selecciona "**Ultra**"
- **Si tienes RTX 3070**: Selecciona "**High**"
- **Si tienes RTX 2060/3060**: Selecciona "**Medium**"
- **Si quieres máximo FPS**: Selecciona "**Low**"

### Paso 2: Ajustar Configuración de Video
```
Distancia de renderizado: 16-32 chunks
Suavizado: Desactiva (FXAA)
VBO: Activado
Mip-mapping: Activado
```

### Paso 3: Activar Características
En **Shader Options → Advanced**:
- God Ray Intensity: `0.8` (o ajusta a tu gusto)
- Bloom Intensity: `1.0`
- Shadow Strength: `0.8`

---

## 🎮 CONTROLES EN-JUEGO

Una vez que el shader está activo:

### Acceder a Configuración de Shaders:
1. **Pausa el juego** (ESC)
2. Ve a: **Opciones → Configuración de Video**
3. Haz clic en: **Shader Options** o **Configuración de Shaders**
4. Aquí puedes ajustar en tiempo real:
   - Intensidad de god rays
   - Altura de ondas de agua
   - Calidad de sombras
   - Bloom y efectos

### Cambiar entre Perfiles:
1. En **Shader Options**
2. Busca: **Profile** (Perfil)
3. Selecciona: **Ultra/High/Medium/Low**
4. Los valores se cambian automáticamente

---

## 🔧 TROUBLESHOOTING (Solución de Problemas)

### ❌ "El shader no se carga" / "Error de compilación"

**Solución:**
1. Verifica que Iris esté instalado correctamente
2. Verifica que Sodium esté instalado
3. Elimina la carpeta `shaderpacks` completamente
4. Copia el ZIP nuevamente
5. Reinicia Minecraft
6. Revisa: `logs/latest.log` para detalles

### ❌ "Muy bajo rendimiento"

**Solución:**
1. Cambia a perfil "**Medium**" o "**Low**"
2. Reduce:
   - Shadow Distance: `512`
   - God Ray Steps: `16`
   - Bloom Radius: `4`
3. Verifica que solo Fabric + Iris + Sodium estén instalados
4. Desactiva otros mods gráficos

### ❌ "Sombras pixeladas"

**Solución:**
1. Cambia a perfil "**Ultra**"
2. Aumenta:
   - Shadow Distance: `2048`
   - Shadow Strength: `0.9`
3. Actualiza drivers GPU
4. Verifica VRAM disponible

### ❌ "Agua muy distorsionada"

**Solución:**
1. En Shader Options, reduce:
   - Wave Amplitude: `0.15`
   - Wave Speed: `0.3`
   - Normal Map Strength: `0.2`
2. Aumenta Water Transparency: `0.8`

### ❌ "Minecraft no inicia"

**Solución:**
1. Verifica versiones:
   - Minecraft: `1.21.11`
   - Fabric: `1.21.11`
   - Iris: `1.10.7+1.21.1`
   - Sodium: `0.8.7+1.21.1`
2. Elimina mods conflictivos (Optifine, otros shaderpacks)
3. Ejecuta Minecraft en modo windowed
4. Aumenta RAM asignada: `4GB`

---

## 📊 VERIFICACIÓN DE INSTALACIÓN

Verifica que tengas estos archivos:

```
.minecraft/
├── mods/
│   ├── iris-1.10.7+1.21.1.jar ✓
│   └── sodium-fabric-0.8.7+mc1.21.1.jar ✓
├── shaderpacks/
│   └── ShaderPackSUPREME.zip ✓
└── versions/
    └── 1.21.11-fabric ✓
```

---

## 🎯 RENDIMIENTO ESPERADO

### Después de instalar correctamente:

| GPU | Ultra | High | Medium | Low |
|-----|-------|------|--------|-----|
| RTX 3090 | 144+ | 200+ | 300+ | 500+ |
| RTX 3080 | 120-144 | 144+ | 200+ | 300+ |
| RTX 3070 | 90-120 | 120-144 | 144+ | 200+ |
| RTX 3060 | 60-80 | 90-120 | 120-144 | 144+ |
| RTX 2060 | 30-45 | 60-80 | 90-120 | 120+ |

*Aproximados a 1080p*

---

## 💾 TIPS ADICIONALES

### Para Máximo Rendimiento:
- Desactiva "Enhanced Graphics" en Minecraft
- Desactiva "Smooth Lighting"
- Usa Render Distance 16-24
- Desactiva Vsync si quieres más FPS
- Cierra otras aplicaciones

### Para Máxima Calidad:
- Usa perfil "Ultra"
- Aumenta Render Distance a 32
- Usa resolución nativa de monitor
- Activa FPS Target a 60 para estabilidad
- Asigna máximo RAM (8GB+)

### Mods Compatibles Recomendados:
- Entity Culling (optimización)
- Lithium (optimización)
- Phosphor (iluminación)
- Tweakeroo (utilidades)

---

## ✅ ¡TODO LISTO!

Si seguiste todos los pasos correctamente, deberías:
- ✅ Tener Minecraft con Fabric 1.21.11
- ✅ Tener Iris y Sodium instalados
- ✅ Tener el shader pack SUPREME activo
- ✅ Ver gráficos increíbles
- ✅ Disfrutar de god rays, sombras, y agua ondulante

---

## 📞 ¿PROBLEMAS?

1. Revisa esta guía nuevamente
2. Verifica logs/latest.log
3. Comprueba versiones exactas
4. Intenta en folder .minecraft limpia
5. Reinicia tu PC

---

**¡¡¡Que disfrutes Minecraft con gráficos SUPREMOS!!!**

🎮✨🌟
