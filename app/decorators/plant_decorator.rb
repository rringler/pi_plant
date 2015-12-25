class PlantDecorator < Draper::Decorator
  delegate_all

  def moisture_gauge
    LazyHighCharts::HighChart.new('gauge') do |f|
      f.title(text: 'Last Moisture Sample')
      f.chart(
        type: 'gauge',
        plotBackgroundColor: nil,
        plotBackgroundImage: nil,
        plotBorderWidth: 1,
        plotShadow: false,
        height: 170,
        width: 300
      )
      f.pane(
        startAngle: -45,
        endAngle: 45,
        background: nil,
        center: [
          '50%',
          '155%'
        ],
        size: 300
      )
      f.yAxis(
        min: 0,
        max: 100,
        minorTickPosition: 'outside',
        tickPosition: 'outside',
        lineWidth: 2,
        offset: -15,
        tickLength: 15,
        labels: {
          distance: -20,
          rotation: 'auto'
        },
        plotBands: [
          {
            from: 0,
            to: object.moisture_threshold,
            color: '#f0dbdb',
            innerRadius: '90%',
            outerRadius: '105%'
          },
          {
            from: object.moisture_threshold,
            to: [object.moisture_threshold * 1.20, 100].min,
            color: '#fcf8e1',
            innerRadius: '90%',
            outerRadius: '105%'
          },
          {
            from: [object.moisture_threshold * 1.20, 100].min,
            to: 100,
            color: '#ddf0d5',
            innerRadius: '90%',
            outerRadius: '105%'
          }
        ],
        pane: 0
      )
      f.series(
        name: 'Moisture',
        data: [object.samples.most_recent.moisture],
        tooltip: {
          valueSuffix: ' %'
        }
      )
    end
  end

  def moisture_histogram
    LazyHighCharts::HighChart.new('spline') do |f|
      f.title(text: 'Last 30 Days')
      f.chart(
        height: 170,
        width: 300
      )
      f.xAxis(
        type: 'datetime',
        labels: {
          format: "{value:%e-%b}"
        }
      )
      f.yAxis(
        title: {
          text: 'Moisture %'
        },
        min: 0,
        max: 100,
        plotBands: [
          {
            from: 0,
            to: object.moisture_threshold,
            color: '#f0dbdb'
          },
          {
            from: object.moisture_threshold,
            to: [object.moisture_threshold * 1.20, 100].min,
            color: '#fcf8e1'
          },
          {
            from: [object.moisture_threshold * 1.20, 100].min,
            to: 100,
            color: '#ddf0d5'
          }
        ]
      )
      f.series(
        name: 'Moisture',
        type: 'line',
        data: object.samples.recent.map { |s| [js_date(s.created_at), s.moisture] },
        tooltip: {
          useHTML: true,
          xDateFormat: '%a, %e-%b',
          valueSuffix: ' %'
        }
      )
      f.legend(enabled: false)
    end
  end

  def js_date(date)
    # JS stores dates as the number of milliseconds after epoch,
    # while Ruby stores dates as the number of full seconds
    (date.to_f * 1000).to_i
  end
end
