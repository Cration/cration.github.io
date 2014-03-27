---
layout: post
title: "贝塞尔曲线的递归绘制"
description: "　　简要介绍了贝塞尔曲线，并给出了javascript的一种递归绘制方式。"
category: "math"
tags: [数学, javascript, 贝塞尔曲线]
---
{% include JB/setup %}

　　贝塞尔曲线是计算机图形学中的一种重要曲线，给定一些参考点，根据曲线的定义，可以计算出整个曲线的方程。根据给定点的个数，可以分为一次（线性）贝塞尔曲线、二次贝塞尔曲线、三次贝塞尔曲线...

　　n次贝塞尔曲线的一般定义：给定点$P_0$、$P_1$、$P_2$ ... $P_n$，其贝赛尔曲线为：

$$B(t)=\sum_{i=0}^{n}\begin{pmatrix}n\\i\end{pmatrix}P_i(1-t)^{n-i}t^i$$

　　也可以用递归的方式表达，用$B_{P_0 P_1 \dots P_n}$表示由点$P_0 P_1 \dots P_n$确定的贝塞尔曲线，那么

$$B_{P_0 P_1 \dots P_n}(t)=(1-t)B_{P_0 P_1 \dots P_{n-1}}(t)+tB_{P_1 P_2 \dots P_n}(t)$$

　　用自然语言来描述，即：n次贝塞尔曲线是由n-1次贝塞尔曲线插值得到的。利用这个递归定义，我们可以实现对贝塞尔曲线的递归绘制，下面是一个javascript实现的实例。

<div style="text-align: center;">
    <canvas id="democanvas"  width="300px" height="300px"></canvas>
</div>
<script type="text/javascript">
    var P0 = {x:6, y:6};
    var P1 = {x:100, y:250};
    var P2 = {x:150, y:50};
    var P3 = {x:240, y:260};
    var P4 = {x:290, y:20};

    (function()
    {
        var canvas = document.getElementById('democanvas');

        if(canvas.getContext)
        {  
            var ctx = canvas.getContext('2d');  

            renderUI(ctx, arguments);

            var arg = arguments;
            window.setInterval(function(){
                strokeBezierLine(ctx, arg);
            }, 30);
        } 

        function strokeLine(ctx,P0,P1){
            ctx.beginPath(); 
            ctx.lineWidth = 3;
            ctx.lineCap = 'round';
            ctx.strokeStyle = "rgba(205,205,205,1)";
            ctx.moveTo(P0.x,P0.y);
            ctx.lineTo(P1.x,P1.y);
            ctx.stroke();
        }

        function strokeCircle(ctx,p,r)
        {
            ctx.beginPath();
            ctx.arc(p.x, p.y, r, 0, Math.PI*2, true); 
            ctx.stroke();
        }

        var bezierPoints = new Array();
        var t = 0;
        var n = 0;
        var N = 100;

        function strokeBezierLine(ctx, arguments)
        {
            ctx.clearRect(0,0,300,300);
            renderUI(ctx, arguments);
            if(n > N)
            {
                n = 0;
                bezierPoints.length = 0;
            }
            t = n / N;
            bezierPoints[n] = drawMidLine(ctx, t, "rgba(255,0,0,1)", arguments);
            ++n;

            for (var i = 1, len = bezierPoints.length; i < len; ++i)
            {
                ctx.beginPath(); 
                ctx.lineWidth = 2;
                ctx.lineCap = 'round';
                ctx.strokeStyle = "rgba(0, 255, 255, 1)";
                ctx.moveTo(bezierPoints[i-1].x, bezierPoints[i-1].y);
                ctx.lineTo(bezierPoints[i].x, bezierPoints[i].y);
                ctx.stroke();
            }
        }

        function drawMidLine(ctx, t, color, arguments)
        {
            if (arguments.length > 2)
            {
                var arrP = new Array();

                arrP[0] = {
                    x: (1-t)*arguments[0].x + t*arguments[1].x, 
                    y: (1-t)*arguments[0].y + t*arguments[1].y
                };

                for (var i = 1, len = arguments.length; i < len - 1; ++i)
                {
                    arrP[i] = {
                        x: (1-t)*arguments[i].x + t*arguments[i+1].x, 
                        y: (1-t)*arguments[i].y + t*arguments[i+1].y
                    };

                    ctx.beginPath(); 
                    ctx.lineWidth = 2;
                    ctx.lineCap = 'round';
                    ctx.strokeStyle = color;
                    ctx.moveTo(arrP[i-1].x, arrP[i-1].y);
                    ctx.lineTo(arrP[i].x, arrP[i].y);
                    ctx.stroke();
                }

                color = changeColor(color);
                return drawMidLine(ctx, t, color, arrP);
            }
            else
            {
                var P = {
                        x: (1-t)*arguments[0].x + t*arguments[1].x, 
                        y: (1-t)*arguments[0].y + t*arguments[1].y
                    };
                return P;
            }
        }

        function changeColor(color)
        {
            switch (color)
            {
                case "rgba(255,0,0,1)":
                    color = "rgba(0,255,0,1)";
                    break;
                case "rgba(0,255,0,1)":
                    color = "rgba(0,0,255,1)";
                    break;
                case "rgba(0,0,255,1)":
                    color = "rgba(255,0,0,1)";
                    break
                default:
                    color = "rgba(255,0,0,1)";
                    break;
            }
            return color;
        }

        function renderUI(ctx, arguments)
        {
            //绘制起始点、控制点、终点
            for (var i = 0, len = arguments.length; i < len - 1; i++)
            {
                strokeLine(ctx, arguments[i], arguments[i+1]);
            }

            ctx.strokeStyle = "rgba(0,0,0,1)";
            for (var i = 0, len = arguments.length; i < len; i++)
            {
                strokeCircle(ctx, arguments[i], 3);
            }
        }
    })(P0, P1, P2, P3, P4);
</script>

　　实现代码如下：
    <div style="text-align: center;">
        <canvas id="democanvas"  width="300px" height="300px"></canvas>
    </div>
    <script type="text/javascript">
        var P0 = {x:6, y:6};
        var P1 = {x:100, y:250};
        var P2 = {x:150, y:50};
        var P3 = {x:240, y:260};
        var P4 = {x:290, y:20};

        (function()
        {
            var canvas = document.getElementById('democanvas');

            if(canvas.getContext)
            {  
                var ctx = canvas.getContext('2d');  

                renderUI(ctx, arguments);

                var arg = arguments;
                window.setInterval(function(){
                    strokeBezierLine(ctx, arg);
                }, 30);
            } 

            function strokeLine(ctx,P0,P1){
                ctx.beginPath(); 
                ctx.lineWidth = 3;
                ctx.lineCap = 'round';
                ctx.strokeStyle = "rgba(205,205,205,1)";
                ctx.moveTo(P0.x,P0.y);
                ctx.lineTo(P1.x,P1.y);
                ctx.stroke();
            }

            function strokeCircle(ctx,p,r)
            {
                ctx.beginPath();
                ctx.arc(p.x, p.y, r, 0, Math.PI*2, true); 
                ctx.stroke();
            }

            var bezierPoints = new Array();
            var t = 0;
            var n = 0;
            var N = 100;

            function strokeBezierLine(ctx, arguments)
            {
                ctx.clearRect(0,0,300,300);
                renderUI(ctx, arguments);
                if(n > N)
                {
                    n = 0;
                    bezierPoints.length = 0;
                }
                t = n / N;
                bezierPoints[n] = drawMidLine(ctx, t, "rgba(255,0,0,1)", arguments);
                ++n;

                for (var i = 1, len = bezierPoints.length; i < len; ++i)
                {
                    ctx.beginPath(); 
                    ctx.lineWidth = 2;
                    ctx.lineCap = 'round';
                    ctx.strokeStyle = "rgba(0, 255, 255, 1)";
                    ctx.moveTo(bezierPoints[i-1].x, bezierPoints[i-1].y);
                    ctx.lineTo(bezierPoints[i].x, bezierPoints[i].y);
                    ctx.stroke();
                }
            }

            function drawMidLine(ctx, t, color, arguments)
            {
                if (arguments.length > 2)
                {
                    var arrP = new Array();

                    arrP[0] = {
                        x: (1-t)*arguments[0].x + t*arguments[1].x, 
                        y: (1-t)*arguments[0].y + t*arguments[1].y
                    };

                    for (var i = 1, len = arguments.length; i < len - 1; ++i)
                    {
                        arrP[i] = {
                            x: (1-t)*arguments[i].x + t*arguments[i+1].x, 
                            y: (1-t)*arguments[i].y + t*arguments[i+1].y
                        };

                        ctx.beginPath(); 
                        ctx.lineWidth = 2;
                        ctx.lineCap = 'round';
                        ctx.strokeStyle = color;
                        ctx.moveTo(arrP[i-1].x, arrP[i-1].y);
                        ctx.lineTo(arrP[i].x, arrP[i].y);
                        ctx.stroke();
                    }

                    color = changeColor(color);
                    return drawMidLine(ctx, t, color, arrP);
                }
                else
                {
                    var P = {
                            x: (1-t)*arguments[0].x + t*arguments[1].x, 
                            y: (1-t)*arguments[0].y + t*arguments[1].y
                        };
                    return P;
                }
            }

            function changeColor(color)
            {
                switch (color)
                {
                    case "rgba(255,0,0,1)":
                        color = "rgba(0,255,0,1)";
                        break;
                    case "rgba(0,255,0,1)":
                        color = "rgba(0,0,255,1)";
                        break;
                    case "rgba(0,0,255,1)":
                        color = "rgba(255,0,0,1)";
                        break
                    default:
                        color = "rgba(255,0,0,1)";
                        break;
                }
                return color;
            }

            function renderUI(ctx, arguments)
            {
                //绘制起始点、控制点、终点
                for (var i = 0, len = arguments.length; i < len - 1; i++)
                {
                    strokeLine(ctx, arguments[i], arguments[i+1]);
                }

                ctx.strokeStyle = "rgba(0,0,0,1)";
                for (var i = 0, len = arguments.length; i < len; i++)
                {
                    strokeCircle(ctx, arguments[i], 3);
                }
            }
        })(P0, P1, P2, P3, P4);
    </script>

-----------------------------------------------------------------

###References

[维基百科：贝塞尔曲线](http://en.wikipedia.org/wiki/B%C3%A9zier_curve)  
