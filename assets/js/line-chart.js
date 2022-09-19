import Chart from "chart.js/auto";

class LineChart {
  constructor(ctx, labels, values) {
    this.chart = new Chart(ctx, {
      type: "line",
      data: {
        labels: labels,
        fontcolor: ['rgb(243 244 246)', 'rgb(75, 192, 192)', 'rgb(75, 192, 192)'],
        datasets: [
          {
            label: "Weight",
            data: values,
            borderColor: "rgb(75, 192, 192)",
          },
        ],
      },
      options: {
        scales: {
          xAxes: [
            {
              ticks: {
                fontStyle: "bold",
                fontSize: 14,
              },
            },
          ],
          yAxes: [
            {
              ticks: {
                suggestedMin: 50,
                suggestedMax: 200,
                fontStyle: "bold",
                fontSize: 14,
              },
            },
          ],
        },
      },
    });
  }

  addPoint(label, value) {
    const labels = this.chart.data.labels;
    const data = this.chart.data.datasets[0].data;

    labels.push(label);
    data.push(value);

    if (data.length > 12) {
      data.shift();
      labels.shift();
    }

    this.chart.update();
  }

  updateChart() {
    this.chart.update();
  }
}

export default LineChart;
