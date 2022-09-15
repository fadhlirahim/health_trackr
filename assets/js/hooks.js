import LineChart from "./line-chart"

Hooks = {}

Hooks.LineChart = {
  mounted() {
    const { labels, values } = JSON.parse(this.el.dataset.chartData)
    this.chart = new LineChart(this.el, labels, values)

    this.handleEvent("new-point", ({ label, value }) => {
      this.chart.addPoint(label, value)
    })
  }
}

export default Hooks;
