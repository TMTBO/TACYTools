# 砸壳

## dumpdecrypted 使用

### 编译 dumpdecrypted

1. git clone https://github.com/stefanesser/dumpdecrypted.git
2. cd dumpdecrypted && make 编译生成dumpdecrypted.dylib

### 监听进程

1. ps aux | grep (TargetAppName)
2. cycript -p （pid | progress name)

### 查找沙盒路径

1. ```@import com.thriller.cript`````
2. `bundleId`
3. 将 `dumpdecrypted.dylib` 拷贝到 `root` 用户根目录 `scp -P 2222 ./dumpdecrypted.dylib root@localhost:/`
4. 砸壳,执行 DYLD_INSERT_LIBRARIES=dumpdecrypted.dylib /path/to/executable
5. 完成后生成 TargerApp.decrypted
6. 复制备用 scp -P 2222 root@localhost:/path/to/TargerApp.decrypted ./

## Clutch 使用

### 准备

1. 下载 `Clutch` : `https://github.com/KJCracks/Clutch/releases`
2. 将 `Clutch` 拷贝到手机 `/usr/bin` 目录下
3. 添加执行权限: `chmod +x Clutch`

### 使用
 1. `Clutch -i` 查看安装程序信息列表
 2. `Clutch -d <num>` 执行砸壳
