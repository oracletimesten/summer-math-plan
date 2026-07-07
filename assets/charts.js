(function() {
  var style = getComputedStyle(document.documentElement);
  var accent = style.getPropertyValue('--accent').trim();
  var accent2 = style.getPropertyValue('--accent2').trim();
  var ink = style.getPropertyValue('--ink').trim();
  var muted = style.getPropertyValue('--muted').trim();
  var rule = style.getPropertyValue('--rule').trim();
  var bg2 = style.getPropertyValue('--bg2').trim();

  // --- Chart: Roadmap Gantt ---
  var chartDom = document.getElementById('roadmap-chart');
  if (!chartDom) return;

  var chart = echarts.init(chartDom, null, { renderer: 'svg' });

  var categories = [
    '阶段一：数与运算',
    '阶段二：数论入门',
    '阶段三：几何进阶',
    '阶段四：应用题专题'
  ];

  var data = [
    // 阶段一
    { name: '分数四则混合运算', value: [0, 1, 2], itemStyle: { color: accent2 } },
    { name: '分数巧算', value: [0, 2, 3], itemStyle: { color: '#5a9e8e' } },
    { name: '循环小数', value: [0, 2, 3], itemStyle: { color: '#7ab8aa' } },
    { name: '比的应用', value: [0, 4, 5], itemStyle: { color: '#9dd2c6' } },
    // 阶段二
    { name: '余数问题与同余', value: [1, 2, 3], itemStyle: { color: '#d4a04a' } },
    { name: '因数个数定理', value: [1, 3, 4], itemStyle: { color: '#c9a227' } },
    // 阶段三
    { name: '四边形面积关系', value: [2, 4, 5], itemStyle: { color: '#b85c3e' } },
    { name: '燕尾模型', value: [2, 5, 6], itemStyle: { color: '#c75b39' } },
    { name: '圆与扇形', value: [2, 5, 6], itemStyle: { color: '#d97a5c' } },
    // 阶段四
    { name: '多次相遇行程', value: [3, 6, 7], itemStyle: { color: '#8b7ab8' } },
    { name: '水中浸物', value: [3, 7, 8], itemStyle: { color: '#a89cd4' } },
    { name: '分类枚举', value: [3, 7, 8], itemStyle: { color: '#c4b8e0' } },
    { name: '染色与覆盖', value: [3, 7, 8], itemStyle: { color: '#ddd5ec' } }
  ];

  function renderItem(params, api) {
    var categoryIndex = api.value(0);
    var start = api.coord([api.value(1), categoryIndex]);
    var end = api.coord([api.value(2), categoryIndex]);
    var height = api.size([0, 1])[1] * 0.6;

    var rectShape = echarts.graphic.clipRectByRect({
      x: start[0],
      y: start[1] - height / 2,
      width: end[0] - start[0],
      height: height
    }, {
      x: params.coordSys.x,
      y: params.coordSys.y,
      width: params.coordSys.width,
      height: params.coordSys.height
    });

    return rectShape && {
      type: 'rect',
      transition: ['shape'],
      shape: rectShape,
      style: api.style({ fill: api.visual('color'), stroke: 'transparent' })
    };
  }

  var option = {
    animation: false,
    tooltip: {
      trigger: 'item',
      appendToBody: true,
      formatter: function(params) {
        return '<strong>' + params.data.name + '</strong><br/>第 ' + (params.data.value[1] + 1) + ' 周 ~ 第 ' + params.data.value[2] + ' 周';
      }
    },
    grid: {
      top: 40,
      bottom: 30,
      left: 120,
      right: 30,
      height: 'auto'
    },
    xAxis: {
      type: 'value',
      min: 0,
      max: 8,
      interval: 1,
      axisLabel: {
        formatter: function(val) {
          return val === 0 ? '开始' : '第' + val + '周';
        },
        color: muted,
        fontSize: 12
      },
      splitLine: {
        lineStyle: { color: rule, type: 'dashed' }
      },
      axisLine: { lineStyle: { color: rule } },
      axisTick: { show: false }
    },
    yAxis: {
      type: 'category',
      data: categories,
      axisLabel: {
        color: ink,
        fontSize: 12,
        fontWeight: 500
      },
      axisLine: { show: false },
      axisTick: { show: false },
      splitLine: { show: false }
    },
    series: [{
      type: 'custom',
      renderItem: renderItem,
      itemStyle: {
        opacity: 0.85,
        borderRadius: 4
      },
      label: {
        show: true,
        position: 'inside',
        formatter: function(params) {
          var w = params.data.value[2] - params.data.value[1];
          return w >= 1 ? params.data.name : '';
        },
        color: '#fff',
        fontSize: 11,
        fontWeight: 500
      },
      encode: {
        x: [1, 2],
        y: 0
      },
      data: data
    }]
  };

  chart.setOption(option);
  window.addEventListener('resize', function() { chart.resize(); });
})();
