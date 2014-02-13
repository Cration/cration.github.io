---
layout: post
title: "代码技巧【不定期更新】"
description: "　　散乱记录一些编程技巧和代码技巧。"
category: "Program"
tags: [C, 编程技巧]
update: 2014-02-13
---
{% include JB/setup %}

>初始化函数的开始, 可以用一个static变量作为标志, 保证功能只被初始化一次. 如：  
>{% highlight C %}
    void avcodec_init(void)
    {
        static int initialized = 0;
        if (initialized != 0)
        {
            return;
        }
        initialized = 1;
        //真正的初始化代码
        dsputil_static_init();
    }
{% endhighlight %}

>递归与循环在编程模型和思维模型上最大的区别在于:  
>　　循环是在描述我们该如何地去解决问题.  
>　　递归是在描述这个问题的定义.  

>宏中使用do{...} while(0)来保证安全性

>辗转相除求最大公约数:
>{% highlight C %}
//其中a大于b
int gcd(int a, int b)
{
    return b ? gcd(b, a % b) : a;
}
{% endhighlight %}>
>或者如下:
>{% highlight C %}
while(a%=b^=a^=b^=a);
{% endhighlight %}

>判断一个数是否为2的次幂：
>{% highlight C %}
    return (!(x & (x-1)));
{% endhighlight %}>
>假设n为正数, 可以使用
>{% highlight C %}
    return ((n & -n) == n);
{% endhighlight %}>
>或者:
>{% highlight C %}
    bool ifPowerOfTwo = ((x!=0)&&((~x+1)&x==x));
{% endhighlight %}

>Isolates last non zero digit of a's binary representation.
>{% highlight C %}
a -= (a & -a);
{% endhighlight %}

>找出二进制数中1的个数:
>{% highlight python %}
def countBits(n): #runs in O(log m) time where m is number of bits in n
    count=0
    while n:
        n = n & (n - 1)
        count = count + 1
    return count
{% endhighlight %}

>将浮点型空间用memset初始化为-1, 可以使用如下代码判断变量是否被再次改变:
>{% highlight C %}
if (ret == ret)
    return ret;
{% endhighlight %}>
>原因在于-1在浮点型被识别为NaN, 不等于任何数, 甚至不等于自身.

>计算一个二进制数中1的数量:
>{% highlight C %}
    for(c=0; v; ++c)
        v &= v - 1;
{% endhighlight %}

>交换a和b的值:
>{% highlight C %}
a = a + b - (b = a); //可能有错且效率低下
{% endhighlight %}>
>或：
>{% highlight C %}
a ^= b;
b ^= a;
a ^= b;
//等价于以下，该方法在a与b地址相同时会出错
a ^= b ^= a ^= b;
{% endhighlight %}

>雷神之锤3中平方根倒数算法:
>{% highlight C %}
float FastInvSqrt(float x)
{
    float xhalf = 0.5f * x;
    int i = *(int*)&x;          // evil floating point bit level hacking
    i = 0x5f3759df - (i >> 1);  // what the fuck?
    x = *(float*)&i;
    x = x*(1.5f-(xhalf*x*x));
    return x;
}
{% endhighlight %}

>二分查找:
>{% highlight C %}
    int lo = 0, hi = N;
    for(int mid = (lo + hi)/2; hi - lo > 1; mid = (lo + hi)/2)
        (arr[mid] > x? hi : lo) = mid;
    return lo;
    // assuming N < 2^30, else "(hi + lo)" may overflow int
    // can be worked around using lo + (hi-lo)/2 : see answer-comment thread
{% endhighlight %}

>整数乘法:
>{% highlight C %}
public static int multiply (int a, int b)
{
    return b==0?0:((b&1) ==1?a:0)+multiply(a<<1,b>>1);
}
{% endhighlight %}

>预编译与文件的使用技巧:
>{% highlight C %}
double normals[][] =
{
    #include "normals.txt"
};
{% endhighlight %}

>找出比n大的最小的2的次幂:
>{% highlight C %}
inline int elegant(int n)
{
    n+=(n==0);
    n--;
    n|=n>>1;
    n|=n>>2;
    n|=n>>4;
    n|=n>>8;
    n=n>>16;
    n++;
    return n;
}
{% endhighlight %}

>结构体末尾使用长度为0的数组, 便于扩展, 比如用malloc给结构体分配空间, 加上一段长度作为扩展的数据.

>使用__COUNTER__宏来计数  
>使用__DATE__   __TIME__  __FILE__  __LINE__   __func__ 宏

>使用` while(!scanf()) `来遇到EOF时结束读取

>使用offsetof宏来获取结构体成员偏移量
>{% highlight C %}
    #include <stdio.h>
    #include <stdlib.h>
    #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
    //定义结构体和结构体变量
    struct abc
    {
        int a;
        int b[4];
        int c;
    } abc_inst;
    //打印偏移量
    int main()
    {
        printf ("%lu %lu %lu\n", offsetof(struct abc, a), 
                            offsetof(struct abc, b), 
                            offsetof(struct abc, c));
        return 0;
    }
{% endhighlight %}

>scanf的高级用法:  
>[http://blog.csdn.net/wesweeky/article/details/6439777](http://blog.csdn.net/wesweeky/article/details/6439777)

>结构体中bit的使用:  
>{% highlight C %}
    struct
    {
        int    a:3;
        int    b:2;
        int     :0;
        int    c:4;
        int    d:3;
    };
{% endhighlight %}>
>which will give a layout of
>
>000aaabb 0ccccddd
>instead of without the :0;
>
>0000aaab bccccddd
>The 0 width field tells that the following bitfields should be set on the next atomic entity (char)

>使用 ` #pragma message() ` 向编译信息窗口输出信息
>使用 ` #error ... ` 中断编译

>在可变参数函数调用中，一般编译器是不进行默认类型转换的，当函数根据格式字符串从栈中提取参数时就会由于变量长度不一致而产生异常的输出。

>单行注释中的末尾换行符可能导致bug, 如下:   
>{% highlight C %}
//将文件a.log保存到目录: C:\
SaveFile(file, "C:\\a.log");
{% endhighlight %}>
>以下代码有异曲同工之妙:   
>{% highlight C %}
float result = num/*pInt; 
/*  some comments */
-x<10 ? f(result):f(-result);
{% endhighlight %}


>"??! is a trigraph that translates to | ."
>所以可以用"??!"代替"|"使用, 可能起到迷惑作用.
>这实际上是C语言为老式键盘设计的特性，称之为“三字母词”（trigraph）。

<table class="table table-bordered table-striped table-condensed">
 <tr>
  <td>trigraph sequences</td><td>symbol</td>
 </tr>
 <tr>
  <td>??=</td><td>#</td>
 </tr>
 <tr>
  <td>??(</td><td>[</td>
 </tr>
 <tr>
  <td>??/</td><td>\</td>
 </tr>
 <tr>
  <td>??)</td><td>\</td>
 </tr>
 <tr>
  <td>??'</td><td>^</td>
 </tr>
 <tr>
  <td>??<</td><td>{</td>
 </tr>
 <tr>
  <td>??!</td><td>|</td>
 </tr>
 <tr>
  <td>??></td><td>}</td>
 </tr>
 <tr>
  <td>??-</td><td>~</td>
 </tr>
</table>

>sizeof()是一个编译时的运算符, 不会对括号内的表达式进行求值.

>将数组单独定义为结构体, 可以在参数传递时按值传递. 如下:
>{% highlight C %}
struct ABC
{
    char array[100];
}abc;
{% endhighlight %}

>在C语言中, 大括号仅仅作为"命名空间"的作用, 并没有"堆栈边界"的作用.

>Look up the access() function. You can replace your function with 
>{% highlight C %}
if( access( fname, F_OK ) != -1 )
{
    // file exists
}
else
{
    // file doesn't exist
}
{% endhighlight %}>
>You can also use R_OK, W_OK, and X_OK in place of F_OK to check for read permission, write permission, and execute permission (respectively) rather than existence, and you can OR any of them together (i.e. check for both read and write permission using R_OK|W_OK)  
>Update: Note that on Windows, you can't use W_OK to reliably test for write permission, since the access function does not take DACLs into account. access( fname, W_OK ) may return 0 (success) because the file does not have the read-only attribute set, but you still may not have permission to write to the file.

>使用三目运算符?:对const变量进行初始化:
>{% highlight C %}
const int bytesPerPixel = isAlpha() ? 4 : 3;
{% endhighlight %}

>使用 ` do{...} while(0); ` 可以在循环体中用break代替goto语句.

>可以用宏实现(不通过传地址而改变变量的值)的功能.

>函数回调的机制允许了底层代码调用在高层定义的功能. 例如, 库可以调用使用者定义的功能.

>不使用判断和循环, 打印1-1000的所有数字:
>{% highlight C %}
    #include "stdio.h"
    #include "stdlib.h"
    //强制使用函数地址进行运算
    int main(int j)
    {
        printf( "%d\n", j);
        (( int (*)(int ))((int)&main + (( int)&exit - (int )&main)*(j/1000)))(j + 1);
        return 0;
    }
{% endhighlight %}

>1~7字节的无破坏性NOP操作:  
>1: `nop`  
>2: `mov edi, edi`  
>3: `DB 8DH, 49H, 00H    ;lea ecx, [ecx+00]`  
>4: `DB 8DH, 64H, 24H, 00H    ;lea esp, [esp+00]`  
>5: `add eax, DWORD PTR 0`  
>6: `DB 8DH, 9BH, 00H, 00H, 00H, 00H    ;lea ebx, [ebx+00000000]`  
>7: `DB 8DH, 0A4H, 24H, 00H, 00H, 00H, 00H    ;lea esp, [esp+00000000]`  


>使用&&可以取出label的地址. (gcc特性)

>C语言的{}代码块是有值的, 值为最后一个表达式的值.


>Numbers Everyone Should Know from Google

<table class="table table-bordered table-striped table-condensed">
 <tr>
  <td>trigraph sequences</td><td>time</td>
 </tr>
 <tr>
  <td>L1 cache reference</td><td>0.5ns</td>
 </tr>
 <tr>
  <td>Branch mispredict</td><td>5ns</td>
 </tr>
 <tr>
  <td>L2 cache reference</td><td>7ns</td>
 </tr>
 <tr>
  <td>Mutex lock/unlock</td><td>25ns</td>
 </tr>
 <tr>
  <td>Main memory reference</td><td>100ns</td>
 </tr>
 <tr>
  <td>Compress 1K bytes with Zippy</td><td>10,000ns</td>
 </tr>
 <tr>
  <td>Send 2K bytes over 1 Gbps network</td><td>20,000ns</td>
 </tr>
 <tr>
  <td>Read 1 MB sequentially from memory</td><td>250,000ns</td>
 </tr>
 <tr>
  <td>Round trip within same datacenter</td><td>500,000ns</td>
 </tr>
 <tr>
  <td>Read 1 MB sequentially from memory</td><td>1,000,000ns</td>
 </tr>
 <tr>
  <td>Disk seek</td><td>10,000,000</td>
 </tr>
 <tr>
  <td>Read 1 MB sequentially from network</td><td>10,000,000</td>
 </tr>
 <tr>
  <td>Read 1 MB sequentially from disk</td><td>30,000,000</td>
 </tr>
 <tr>
  <td>Send packet CA->Netherlands->CA</td><td>150,000,000</td>
 </tr>
</table>

>使用_alloca函数可以在栈上分配内存，以实现变长数组之类的应用。

