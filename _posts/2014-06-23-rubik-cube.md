---
layout: post
title: "三阶魔方四步法盲拧的C语言实现"
description: "　　以C语言实现了三阶魔方的四步法盲拧步骤，输入魔方状态，输出盲拧步骤。"
category: "program"
tags: [C]
---
{% include JB/setup %}

　　Makeblock第五届创客马拉松，本组的主题是魔方机器人。

　　定义六个面的色块顺序如以下两图：

![ULF]({{site.img_path}}/Cube_ULF.png)

![DRB]({{site.img_path}}/Cube_DRB.png)

　　实现代码如下：

{% highlight C %}
#include "stdio.h"

#define C_U 1
#define C_D 2
#define C_F 4
#define C_B 8
#define C_L 16
#define C_R 32

#define U 0
#define D 1
#define F 2
#define B 3
#define L 4
#define R 5

//  角搭桥
char throughBridgeCorner[8][10] = {"", "", "RRDBB", "RRBB", "DDBB", "dBB", "BB", "DBB"};
//  角反搭桥
char backBridgeCorner[8][10] = {"", "", "BBdRR", "BBRR", "BBDD", "BBD", "BB", "BBd"};

//  棱向搭桥
char throughBridgeEdge[12][10] = {"", "lb", "", "RB", "DDBB", "dBB", "BB", "DBB", "RRB", "LLB", "b", "B"};
//  棱向反搭桥
char backBridgeEdge[12][10] = {"", "BL", "", "br", "BBDD", "BBD", "BB", "BBd", "bRR", "bLL", "B", "b"};

//  棱位搭桥
// char throughBridgeEdgePos[12][10] = {"", "", "MDmS", "RRSS", "DSS", "DDSS", "dSS", "SS", "rSS", "KKRSS", "KKrSS", "RSS"};
char throughBridgeEdgePos[12][20] = {"", "", "LrMDlRmfBS", "RRffBBSS", "DffBBSS", "DDffBBSS", "dffBBSS", "ffBBSS", "rffBBSS", "uuDDKKRffBBSS", "uuDDKKrffBBSS", "RffBBSS"};
//  棱位反搭桥
// char backBridgeEdgePos[12][10] = {"", "", "sMdm", "SSRR", "SSd", "SSDD", "SSD", "SS", "SSR", "SSrKK", "SSRKK", "SSr"};
char backBridgeEdgePos[12][20] = {"", "", "sLrMdlRm", "ffBBSSRR", "ffBBSSd", "ffBBSSDD", "ffBBSSD", "ffBBSS", "ffBBSSR", "ffBBSSruuDDKK", "ffBBSSRuuDDKK", "ffBBSSr"};

//  翻角顺
char adjustCorner1[] = "RUrURUUrluLulUUL";
//  翻角逆
char adjustCorner2[] = "lUULUlULRUUruRur";
//  翻棱
// char adjustEdge[] = "mUmUmUUMUMUMUU";
char adjustEdge[] = "lRBlRDlRFFLrDLrBLrUU";
//  棱角换
char switchBlock[] = "RulUrUULulUUL";


void GetCornerDir(int state[6][9], int cornerDir[8]);
void GetEdgeDir(int state[6][9], int edgeDir[12]);
void GetCornerPos(int state[6][9], int cornerPos[12]);
void GetEdgePos(int state[6][9], int edgePos[36]);

int FindRightCorner(int color1, int color2, int color3);
int FindRightEdge(int color1, int color2);


int main(int argc, char const *argv[])
{
    //  初始状态
    int state[6][9] = { {0, 0, 0, 0, 0, 0, 0, 0, 0}, 
                        {0, 0, 0, 0, 0, 0, 0, 0, 0}, 
                        {0, 0, 0, 0, 0, 0, 0, 0, 0}, 
                        {0, 0, 0, 0, 0, 0, 0, 0, 0}, 
                        {0, 0, 0, 0, 0, 0, 0, 0, 0}, 
                        {0, 0, 0, 0, 0, 0, 0, 0, 0} };
 
    //  角块朝向编码
    int cornerDir[8] = {0, 0, 0, 0, 0, 0, 0, 0};
    //  棱块朝向编码
    int edgeDir[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    //  角块位置编码
    int cornerPos[24] = {-1, -1, -1, -1, -1, -1, -1, -1, 
                         -1, -1, -1, -1, -1, -1, -1, -1, 
                         -1, -1, -1, -1, -1, -1, -1, -1};
    //  棱块位置编码
    int edgePos[36] = {-1, -1, -1, -1, -1, -1, -1, -1, 
                       -1, -1, -1, -1, -1, -1, -1, -1, 
                       -1, -1, -1, -1, -1, -1, -1, -1, 
                       -1, -1, -1, -1, -1, -1, -1, -1};

    //  获取角块棱块朝向
    GetCornerDir(state, cornerDir);
    GetEdgeDir(state, edgeDir);
    GetCornerPos(state, cornerPos);
    GetEdgePos(state, edgePos);
    //  输出朝向
    /*
    for (int i = 0; i < 8; ++i)
    {
        printf("%d\n", cornerDir[i]);
    }
    printf("--------------------\n");
    for (int i = 0; i < 12; ++i)
    {
        printf("%d\n", edgeDir[i]);
    }
    //  输出位置
    printf("*****************************\n");
    for (int i = 0; i < 24; ++i)
    {
        printf("%d\n", cornerPos[i]);
    }
    printf("-------------------------------\n");
    for (int i = 0; i < 36; ++i)
    {
        printf("%d\n", edgePos[i]);
    }
    */

    //  输出步骤
    printf("start corner dir:\n");
    for (int i = 1; i < 8; ++i)
    {
        if (1 == cornerDir[i])
        {
            printf("%s\n", throughBridgeCorner[i]);
            printf("%s\n", adjustCorner1);
            printf("%s\n", backBridgeCorner[i]);
        }
        else if (2 == cornerDir[i])
        {
            printf("%s\n", throughBridgeCorner[i]);
            printf("%s\n", adjustCorner2);
            printf("%s\n", backBridgeCorner[i]);
        }
    }

    printf("start edge dir:\n");
    for (int i = 1; i < 12; ++i)
    {
        if (1 == edgeDir[i])
        {
            printf("%s\n", throughBridgeEdge[i]);
            printf("%s\n", adjustEdge);
            printf("%s\n", backBridgeEdge[i]);
        }
    }

    int counter = 0;
    printf("start corner pos:\n");
    for (int i = 0; i < 24; ++i)
    {
        if (-1 != cornerPos[i])
        {
            printf("%s\n", throughBridgeCorner[cornerPos[i]]);
            printf("%s\n", switchBlock);
            printf("%s\n", backBridgeCorner[cornerPos[i]]);
            ++counter;
        }
    }

    //  奇偶校验
    if (1 == counter % 2)
    {
        printf("odd-even check:\n");
        printf("%s\n", switchBlock);
    }
    
    printf("start edge pos:\n");
    for (int i = 0; i < 36; ++i)
    {
        if (-1 != edgePos[i])
        {
            printf("%s\n", throughBridgeEdgePos[edgePos[i]]);
            printf("%s\n", switchBlock);
            printf("%s\n", backBridgeEdgePos[edgePos[i]]);
        }
    }

    return 0;
}

void GetCornerDir(int state[6][9], int cornerDir[8])
{
    //  位置1
    if ((C_U == state[U][6]) || (C_D == state[U][6]))
    {
        cornerDir[0] = 0;
    }
    else if ((C_U == state[L][2]) || (C_D == state[L][2]))
    {
        cornerDir[0] = 1;
    }
    else
    {
        cornerDir[0] = 2;
    }

    //  位置2
    if ((C_U == state[U][0]) || (C_D == state[U][0]))
    {
        cornerDir[1] = 0;
    }
    else if ((C_U == state[B][2]) || (C_D == state[B][2]))
    {
        cornerDir[1] = 1;
    }
    else
    {
        cornerDir[1] = 2;
    }

    //  位置3
    if ((C_U == state[U][2]) || (C_D == state[U][2]))
    {
        cornerDir[2] = 0;
    }
    else if ((C_U == state[R][2]) || (C_D == state[R][2]))
    {
        cornerDir[2] = 1;
    }
    else
    {
        cornerDir[2] = 2;
    }

    //  位置4
    if ((C_U == state[U][8]) || (C_D == state[U][8]))
    {
        cornerDir[3] = 0;
    }
    else if ((C_U == state[F][2]) || (C_D == state[F][2]))
    {
        cornerDir[3] = 1;
    }
    else
    {
        cornerDir[3] = 2;
    }

    //  位置5
    if ((C_U == state[D][8]) || (C_D == state[D][8]))
    {
        cornerDir[4] = 0;
    }
    else if ((C_U == state[F][6]) || (C_D == state[F][6]))
    {
        cornerDir[4] = 1;
    }
    else
    {
        cornerDir[4] = 2;
    }

    //  位置6
    if ((C_U == state[D][2]) || (C_D == state[D][2]))
    {
        cornerDir[5] = 0;
    }
    else if ((C_U == state[L][6]) || (C_D == state[L][6]))
    {
        cornerDir[5] = 1;
    }
    else
    {
        cornerDir[5] = 2;
    }

    //  位置7
    if ((C_U == state[D][0]) || (C_D == state[D][0]))
    {
        cornerDir[6] = 0;
    }
    else if ((C_U == state[B][6]) || (C_D == state[B][6]))
    {
        cornerDir[6] = 1;
    }
    else
    {
        cornerDir[6] = 2;
    }

    //  位置1
    if ((C_U == state[D][6]) || (C_D == state[D][6]))
    {
        cornerDir[7] = 0;
    }
    else if ((C_U == state[R][6]) || (C_D == state[R][6]))
    {
        cornerDir[7] = 1;
    }
    else
    {
        cornerDir[7] = 2;
    }
}

void GetEdgeDir(int state[6][9], int edgeDir[12])
{
    //  棱块1
    edgeDir[0] = (state[U][7] < state[F][1]) ? 0 : 1;
    edgeDir[1] = (state[U][3] < state[L][1]) ? 0 : 1;
    edgeDir[2] = (state[U][1] < state[B][1]) ? 0 : 1;
    edgeDir[3] = (state[U][5] < state[R][1]) ? 0 : 1;
    edgeDir[4] = (state[D][7] < state[F][7]) ? 0 : 1;
    edgeDir[5] = (state[D][5] < state[L][7]) ? 0 : 1;
    edgeDir[6] = (state[D][1] < state[B][7]) ? 0 : 1;
    edgeDir[7] = (state[D][3] < state[R][7]) ? 0 : 1;
    edgeDir[8] = (state[F][5] < state[R][3]) ? 0 : 1;
    edgeDir[9] = (state[F][3] < state[L][5]) ? 0 : 1;
    edgeDir[10] = (state[B][5] < state[L][3]) ? 0 : 1;
    edgeDir[11] = (state[B][3] < state[R][5]) ? 0 : 1;
}

void GetEdgePos(int state[6][9], int edgePos[36])
{
    //  位置0-11
    int edgeIndex[12][2][2] = 
    {
        { {U, 7}, {F, 1} }, 
        { {U, 3}, {L, 1} }, 
        { {U, 1}, {B, 1} }, 
        { {U, 5}, {R, 1} }, 
        { {D, 7}, {F, 7} }, 
        { {D, 5}, {L, 7} }, 
        { {D, 1}, {B, 7} }, 
        { {D, 3}, {R, 7} }, 
        { {F, 5}, {R, 3} }, 
        { {F, 3}, {L, 5} }, 
        { {B, 5}, {L, 3} }, 
        { {B, 3}, {R, 5} }
    };
    //  
    int currentEdgeBlock[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

    for (int i = 0; i < 12; ++i)
    {
        currentEdgeBlock[i] = 
        FindRightEdge(state[edgeIndex[i][0][0]][edgeIndex[i][0][1]], 
                      state[edgeIndex[i][1][0]][edgeIndex[i][1][1]]);
    }

    int pos = 0;
    int count = 0;
    int index = 0;
    int visited[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

    while (count < 12)
    {
        edgePos[index++] = currentEdgeBlock[pos];
        if (1 == visited[pos])
        {
            ++index;
            int i = 0;
            for (i = 0; i < 12; ++i)
            {
                if (0 == visited[i])
                {
                    break;
                }
            }
            pos = i;
        }
        else
        {
            ++count;
            visited[pos] = 1;
            pos = currentEdgeBlock[pos];
        }
    }
    edgePos[index] = currentEdgeBlock[pos];

    //  清除无用的循环
    for (int i = 0; i < 35; ++i)
    {
        if (edgePos[i] == edgePos[i+1])
        {
            edgePos[i] = edgePos[i+1] = -1;
        }
    }
    for (int i = 0; i < 23; ++i)
    {
        if (0 == edgePos[i])
        {
            edgePos[i] = edgePos[i+1] = -1;
        }
    }
}


void GetCornerPos(int state[6][9], int cornerPos[24])
{
    //  位置0-7
    int cornerIndex[8][3][2] = 
    {
        { {U, 6}, {F, 0}, {L, 2} }, 
        { {U, 0}, {L, 0}, {B, 2} }, 
        { {U, 2}, {R, 2}, {B, 0} }, 
        { {U, 8}, {R, 0}, {F, 2} }, 
        { {F, 6}, {L, 8}, {D, 8} }, 
        { {L, 6}, {B, 8}, {D, 2} }, 
        { {R, 8}, {B, 6}, {D, 0} }, 
        { {F, 8}, {R, 6}, {D, 6} }
    };
    //  
    int currentCornerBlock[8] = {0, 0, 0, 0, 0, 0, 0, 0};


    for (int i = 0; i < 8; ++i)
    {
        currentCornerBlock[i] = 
        FindRightCorner(state[cornerIndex[i][0][0]][cornerIndex[i][0][1]], 
                        state[cornerIndex[i][1][0]][cornerIndex[i][1][1]], 
                        state[cornerIndex[i][2][0]][cornerIndex[i][2][1]]);
    }


    int pos = 0;
    int count = 0;
    int index = 0;
    int visited[8] = {0, 0, 0, 0, 0, 0, 0, 0};
    while (count < 8)
    {
        cornerPos[index++] = currentCornerBlock[pos];
        if (1 == visited[pos])
        {
            ++index;
            int i = 0;
            for (i = 0; i < 8; ++i)
            {
                if (0 == visited[i])
                {
                    break;
                }
            }
            pos = i;
        }
        else
        {
            ++count;
            visited[pos] = 1;
            pos = currentCornerBlock[pos];
        }
    }
    cornerPos[index] = currentCornerBlock[pos];


    //  清除无用的搭桥
    for (int i = 0; i < 23; ++i)
    {
        if (cornerPos[i] == cornerPos[i+1])
        {
            cornerPos[i] = cornerPos[i+1] = -1;
        }
    }
    for (int i = 0; i < 23; ++i)
    {
        if (0 == cornerPos[i])
        {
            cornerPos[i] = cornerPos[i+1] = -1;
        }
    }
}

int FindRightEdge(int color1, int color2)
{
    int sum = color1 + color2;
    if (C_U + C_F == sum)
    {
        return 0;
    }
    else if (C_U + C_L == sum)
    {
        return 1;
    }
    else if (C_U + C_B == sum)
    {
        return 2;
    }
    else if (C_U + C_R == sum)
    {
        return 3;
    }
    else if (C_D + C_F == sum)
    {
        return 4;
    }
    else if (C_D + C_L == sum)
    {
        return 5;
    }
    else if (C_D + C_B == sum)
    {
        return 6;
    }
    else if (C_D + C_R == sum)
    {
        return 7;
    }
    else if (C_F + C_R == sum)
    {
        return 8;
    }
    else if (C_F + C_L == sum)
    {
        return 9;
    }
    else if (C_B + C_L == sum)
    {
        return 10;
    }
    else if (C_B + C_R == sum)
    {
        return 11;
    }
    else
    {
        return -1;
    }
}

//  找到角块应该处于的位置
int FindRightCorner(int color1, int color2, int color3)
{
    int sum = color1 + color2 + color3;

    if (C_U + C_L + C_F == sum)
    {
        return 0;
    }
    if (C_U + C_L + C_B == sum)
    {
        return 1;
    }
    if (C_U + C_R + C_B == sum)
    {
        return 2;
    }
    if (C_U + C_R + C_F == sum)
    {
        return 3;
    }
    if (C_D + C_L + C_F == sum)
    {
        return 4;
    }
    if (C_D + C_L + C_B == sum)
    {
        return 5;
    }
    if (C_D + C_R + C_B == sum)
    {
        return 6;
    }
    if (C_D + C_R + C_F == sum)
    {
        return 7;
    }

    return -1;
}
{% endhighlight %}

-------------------------------------------

###References

[盲拧四步法简单教程](http://tieba.baidu.com/p/2036633639?pn=1)  
