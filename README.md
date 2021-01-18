# 42Seoul_ft_server
Introduction to Docker

### dockerfile로 image 생성

`docker build . -t ft_server`

### image 기반 container 생성

`docker run -it -p 80:80 -p 443:443 ft_server`
