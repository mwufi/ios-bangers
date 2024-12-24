import SwiftUI
import Charts
import Foundation

struct StockChartView: View {
    @State private var symbol: String = ""
    @State private var stockData: [StockDataPoint] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                TextField("Enter stock symbol (e.g., AAPL)", text: $symbol)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.allCharacters)
                
                Button("Fetch Data") {
                    Task {
                        await fetchStockData()
                    }
                }
                .disabled(symbol.isEmpty || isLoading)
            }
            .padding()
            
            if isLoading {
                ProgressView()
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else if !stockData.isEmpty {
                Chart(stockData) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Price", dataPoint.price)
                    )
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .frame(height: 300)
                .padding()
                
                Text("Current Price: $\(String(format: "%.2f", stockData.last?.price ?? 0))")
                    .font(.headline)
            }
        }
    }
    
    func fetchStockData() async {
        isLoading = true
        errorMessage = nil
        
        // Construct the Yahoo Finance API URL
        let uppercaseSymbol = symbol.uppercased()
        // Get date range for the past month
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate)!
        
        let period1 = Int(startDate.timeIntervalSince1970)
        let period2 = Int(endDate.timeIntervalSince1970)
        
        guard let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/\(uppercaseSymbol)?period1=\(period1)&period2=\(period2)&interval=1d") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                errorMessage = "Failed to fetch data"
                isLoading = false
                return
            }
            
            let decoder = JSONDecoder()
            let result = try decoder.decode(YahooFinanceResponse.self, from: data)
            
            guard let timestamps = result.chart.result.first?.timestamp,
                  let prices = result.chart.result.first?.indicators.quote.first?.close else {
                errorMessage = "No data available"
                isLoading = false
                return
            }
            
            // Create data points from timestamps and prices
            stockData = zip(timestamps, prices).compactMap { timestamp, price in
                guard let price = price else { return nil }
                return StockDataPoint(
                    date: Date(timeIntervalSince1970: TimeInterval(timestamp)),
                    price: price
                )
            }
            
            isLoading = false
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
            isLoading = false
        }
    }
}

struct StockDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}

// Yahoo Finance API Response structures
struct YahooFinanceResponse: Codable {
    let chart: ChartData
}

struct ChartData: Codable {
    let result: [Result]
}

struct Result: Codable {
    let timestamp: [Int]
    let indicators: Indicators
}

struct Indicators: Codable {
    let quote: [Quote]
}

struct Quote: Codable {
    let close: [Double?]
}

#Preview {
    StockChartView()
}
