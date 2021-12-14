struct EpisodesResultsDTO: Codable {
  let id: Int
  let name: String
  let airDate: String
  let episode: String
  let characters: [String]
  let url: String
  let created: String
}
