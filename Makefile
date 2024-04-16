# 设置相关库和编译器信息，已RV1106的SDK为例
MPP_PATH		= /home/leux/sololinker/media/mpp/release_mpp_rv1106_arm-rockchip830-linux-uclibcgnueabihf
FFMPEG_PATH		= /home/leux/out/ffmpeg
TOOLCHAIN_PATH		= /home/leux/sololinker/tools/linux/toolchain/arm-rockchip830-linux-uclibcgnueabihf
SYSROOT			= $(TOOLCHAIN_PATH)/arm-rockchip830-linux-uclibcgnueabihf/sysroot
STRIP			= $(TOOLCHAIN_PATH)/bin/arm-rockchip830-linux-uclibcgnueabihf-strip
CC			= $(TOOLCHAIN_PATH)/bin/arm-rockchip830-linux-uclibcgnueabihf-gcc

# 设置是否静态编译
ifdef static-compile
	CFLAGS	:= -I $(SYSROOT)/usr/include -I $(MPP_PATH)/include -I $(FFMPEG_PATH)/include -w 
	LDFLAGS	:= -L $(SYSROOT)/usr/lib -L $(MPP_PATH)/lib -L $(FFMPEG_PATH)/lib -static -l:librockchip_mpp.a -l:libavformat.a -l:libavcodec.a -l:libavutil.a -l:libswresample.a -l:libpthread.a -l:libstdc++.a -Wl,-rpath-link $(FFMPEG_PATH)/lib
else
	CFLAGS	:= -I $(SYSROOT)/usr/include -I $(MPP_PATH)/include -I $(FFMPEG_PATH)/include -w 
	LDFLAGS	:= -L $(MPP_PATH)/lib -L $(FFMPEG_PATH)/lib -lrockchip_mpp -lavformat -lavcodec -lavutil -lpthread -Wl,-rpath-link $(FFMPEG_PATH)/lib
endif


m_streamer : streamer.o rtmp.o v4l2.o mpp.o 
	$(CC) -o streamer streamer.o rtmp.o v4l2.o mpp.o  $(LDFLAGS)
	$(STRIP) streamer
streamer.o : streamer.c
	$(CC) -c $(CFLAGS) streamer.c
rtmp.o : rtmp.c
	$(CC) -c $(CFLAGS) rtmp.c
v4l2.o : v4l2.c
	$(CC) -c $(CFLAGS) v4l2.c
mpp.o : mpp.c
	$(CC) -c $(CFLAGS) mpp.c


all : m_streamer 
clean :
	rm *.o streamer
