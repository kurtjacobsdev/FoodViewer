import Vapor

func routes(_ app: Application) throws {
    app.get("foods") { req async throws -> [Food] in
        try await Task.sleep(nanoseconds: 2_000_000_000)
        let path = app.directory.workingDirectory + "Resources/foods/foods.json"
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { throw Abort(.badRequest) }
        guard let items = try? JSONDecoder().decode([Food].self, from: data) else { throw Abort(.badRequest) }
        return items
    }
    
    app.get("foods", "details", ":identifier") { req async throws -> FoodDetail in
        guard let identifier = req.parameters.get("identifier") else { throw Abort(.badRequest) }
        let path = app.directory.workingDirectory + "Resources/foodsDetail/\(identifier).json"
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { throw Abort(.badRequest) }
        guard let item = try? JSONDecoder().decode(FoodDetail.self, from: data) else { throw Abort(.badRequest) }
        return item
    }
}
