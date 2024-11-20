OUTDIR := out
SRCDIR := src

${OUTDIR}/boot.bin: ${SRCDIR}/boot/main.asm
	fasm $? $@ 
