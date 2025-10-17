<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Program Outcome Assessment Report</title>
<style>
body { font-family: DejaVu Sans, sans-serif; font-size: 12px; color: #333; }
h2 { text-align: center; margin-bottom: 20px; }
h3 { margin: 10px 0 5px; color: #2563eb; }
table { width: 100%; border-collapse: collapse; margin-top: 10px; }
th, td { border: 1px solid #999; padding: 4px; text-align: left; }
.text-center { text-align: center; }
.chart-img { display: block; margin: 10px auto; width: 280px; }
</style>
</head>
<body>
    <h2>Program Outcome Assessment Report</h2>
    <p><b>Course:</b> {{ $courseName }} <br>
       <b>Semester:</b> {{ $semester }}</p>

    @foreach($report as $po)
        <h3>{{ $po['po_code'] }} — {{ $po['po_description'] }}</h3>
        <p>
            Mean Rating: <b>{{ $po['mean_rating'] }}</b> • 
            Adjectival: <b>{{ $po['adjectival'] }}</b> • 
            Responses: {{ $po['responses'] }}
        </p>

        @if(isset($po['chart_image']))
            <img src="{{ $po['chart_image'] }}" class="chart-img">
        @endif

        <table>
            <thead>
                <tr>
                    <th>Satisfaction</th>
                    <th>Percentage</th>
                </tr>
            </thead>
            <tbody>
                @foreach($po['distribution'] as $key => $value)
                    <tr>
                        <td>{{ $key }}</td>
                        <td>{{ $value }}%</td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        <hr style="margin:20px 0;">
    @endforeach
</body>
</html>
