# spec2017prgs
Extract benchmark programs from spec2017
# 介绍

本脚本的目标是绕过SPEC2017安装，直接从源码编译运行目标程序。SPEC2017官网给出了不使用`runcpu`命令直接编译运行源码的[教程](https://www.spec.org/cpu2017/Docs/runcpu-avoidance.html)。尽管如此，仍然需要一定的手工工作，因此我提供了一个脚本用于批量抽取SPEC2017所有benchmark源码和编译命令。

由于一些限制，为了使用本脚本，你仍然需要安装好SPEC2017后才能够使用。我在这里列举了本脚本的一些关键特性：

- 你仍然需要在一台机器上完整安装SPEC2017，以便抽取SPEC2017的程序源码，不过这台机器无需是编译或运行benchmark的机器
- 你需要在`$SPEC2017/config`目录下提供一个配置文件，假设你提供的配置文件名是"my_test.cfg"，并将文件名提供给脚本变量

# 使用步骤

## 1. 安装SPEC2017

根据SPEC2017官网的文档完整安装好SPEC2017。

## 2. 配置脚本变量

脚本中下面五个变量都是需要用户提供的，"CONFIGFILE"指定了配置文件，你需要在配置文件里填入编译器路径等信息，最终编译源程序的Makefile文件会使用这里指定的编译器，"SIZE"指定使用什么数据集运行源程序，使用TEST作为测试没有问题，但请在真正运行或进行学术研究时使用REF或TRAIN，"SPECDIR"表示SPEC2017安装目录，"DESDIR"作为输出文件夹目录，如果目录不存在，则脚本会自动创建目录。

```
CONFIGFILE=my_test.cfg
SIZE=test
SPECDIR="/home/allin/spec2017"
DESDIR="/home/allin/specprg" # absulote path
```

特别提醒：请仔细修改"my_test.cfg"文件，因为后续的每一个benchmark程序的"Makefile.spec"都会使用这一配置

## 3. 运行脚本

脚本会在变量"DESDIR"定义的位置生成一个目录。目录结构如下：

```
${DESDIR}/
      .../Makefile.defaults # 从SPEC2017复制过来的Makefile文件，请不要更改此文件
      .../500.perlbench_r/
                      .../build_base_mytest-m64.0000/ # 编译目录
                                                 .../Makefile # 使用`make`命令编译目标benchmark
                                                 .../Makefile.spec # 你需要调整的参数都在这里
                                                 .../compile.sh # 从SPEC2017生成的编译命令，作为参考
                      .../run_base_mytest-m64.0000/ # 运行目录
                                               .../run.sh # 从SPEC2017生成的运行命令，作为参考
```

## 4. 编译

假设你要编译"500.perlbench_r"，请进入编译目录使用`make`进行编译，或者打开"Makefile.spec"修改编译器目录后再编译

## 5. 运行

将编译目录下生成的"perlbench_r"复制到运行目录，进入运行目录，参考"run.sh"运行程序

# Q&A:

Q: error: ISO C++17 does not allow 'register' storage class specifier [-Wregister]
A: add 'std=c++14' to my_test.cfg
Q: IR...
A: clang -emit-llvm *.c -S
