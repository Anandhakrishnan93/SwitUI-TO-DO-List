
import Foundation

@available(iOS 15.0, *)
class HttpClient{
    
    static let shared = HttpClient()
    private init(){
    }
    
    func fetchApi() async throws -> [PrefetchModel]?{
        guard let url = URL(string: domain + endpoint) else {
            return  nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do{
                if let decodedResponse = try? JSONDecoder().decode([PrefetchModel].self, from: data){
                    return decodedResponse
                }else{
                    return nil
                }
            } catch {
                print(error.localizedDescription)
            }
        } catch {
          print(error.localizedDescription)
        }
       return nil
    }

}
