# 砸壳

## 编译 dumpdecrypted

1. git clone https://github.com/stefanesser/dumpdecrypted.git
2. cd dumpdecrypted && make 编译生成dumpdecrypted.dylib

## 监听进程

1. ps aux | grep (TargetAppName)
2. cycript -p （pid | progress name)

## 
5. [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
inDomains:NSUserDomainMask][0]得到沙盒路径
6. scp -P 2222 ./dumpdecrypted.dylib root@localhost:/path/to/TargetAppSandBoox/Documents
7. 签名(ldid -S dumpdecrypted.dylib)
8. cd 到xxx/Documents
9. 砸壳,执行 DYLD_INSERT_LIBRARIES=dumpdecrypted.dylib /path/to/executable
10. 完成后生成 TargerApp.decrypted
11. 复制备用 scp -P 2222 root@localhost:/path/to/TargerApp.decrypted ./
