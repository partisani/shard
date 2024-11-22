OUTDIR := out
SRCDIR := src

${OUTDIR}/boot.img: ${OUTDIR}/os.bin
	-rm $@
	bximage -func=create -q -hd=10M $@
	dd if=$? of=$@ conv=notrunc bs=512

${OUTDIR}/bootloader.bin: ${SRCDIR}/boot/main.asm
	fasm $? $@

${OUTDIR}/kernel.o: ${SRCDIR}/kernel/main.c
	i686-elf-gcc -ffreestanding -m32 -g -c $? -o $@

${OUTDIR}/kernel_init.o: ${SRCDIR}/kernel/kernel_init.asm
	fasm $? $@

${OUTDIR}/kernel.bin: ${OUTDIR}/kernel_init.o ${OUTDIR}/kernel.o
	i686-elf-ld -o $@ -Ttext 0x1000 $^ --oformat "binary"

${OUTDIR}/os.bin: ${OUTDIR}/bootloader.bin ${OUTDIR}/kernel.bin
	cat $^ > ${OUTDIR}/os.bin
