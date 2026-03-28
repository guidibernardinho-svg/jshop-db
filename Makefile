TARGET      := Jshop
APP_TITLE   := Jshop
APP_DESC    := Homebrew store for 3DS
APP_AUTHOR  := SeuUsuario
VERSION_MAJOR := 1
VERSION_MINOR := 0
VERSION_MICRO := 0

# Gera o .t3x a partir do .t3s
$(GFXBUILD)/%.t3x $(BUILD)/%.h : %.t3s
	$(DEVKITPRO)/tools/bin/tex3ds -i $< -H $(BUILD)/$*.h -o $(GFXBUILD)/$*.t3x

# Gera banner e icon
banner.bin:
	@bannertool makebanner -i app/banner.png -a app/banner.wav -o app/banner.bin

icon.bin:
	@bannertool makesmdh \
	  -i app/icon.png \
	  -s "$(APP_TITLE)" \
	  -l "$(APP_DESC)" \
	  -p "$(APP_AUTHOR)" \
	  -o app/icon.bin

# Build CIA
cia: banner.bin icon.bin
	@makerom -f cia \
	  -target t \
	  -exefslogo \
	  -o $(TARGET).cia \
	  -elf $(TARGET).elf \
	  -rsf app/build-cia.rsf \
	  -banner app/banner.bin \
	  -icon app/icon.bin \
	  -major $(VERSION_MAJOR) \
	  -minor $(VERSION_MINOR) \
	  -micro $(VERSION_MICRO)
```

---

### Assets necessários em `app/`
```
app/
├── icon.png        ← 48x48px, ícone do Home Menu
├── banner.png      ← 256x128px, banner do Home Menu
├── banner.wav      ← áudio do banner (PCM 16-bit, 16kHz)
├── banner.bin      ← gerado automaticamente
├── icon.bin        ← gerado automaticamente
├── build-cia.rsf   ← o arquivo acima
└── logo.bcma.lz    ← logo Licensed (pode copiar do Universal-Updater)
```

---

### Fluxo completo
```
push → Actions → devkitARM container
                    ↓
              make (compila .elf)
                    ↓
         bannertool → banner.bin + icon.bin
                    ↓
    makerom → Jshop.cia + Jshop.3dsx
                    ↓
         upload-artifact (todo push)
         upload Release (só em tags)
