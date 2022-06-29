//
//  MovieList.swift
//  ShakuroApp

import Foundation
import UIKit

struct MovieItem {
    let title: String
    let image: UIImage?
    let midImage: UIImage?
    let imdb: String
    let genre: String
    let info: String
    let story: String
    let actor: [Actor]
    let trailer: [Trailer]
    let photo: [Photo]
    let cinema: [Cinema]
    let hasDetails: Bool
}

struct Actor {
    let photo: UIImage?
    let name: String?
    let role: String?

    let age: String?
    let bio: String?
    let actorInfo: [ActorInfo]
    let filmography: [Filmography]

    static func generate() -> [Actor] {
        return [Actor(photo: R.image.actor1(),
                      name: "Keanu Reeves",
                      role: "John Wick",
                      age: "54",
                      bio: "Keanu Charles Reeves, whose first name means cool breeze over the mountains in Hawaiian, was born September 2, 1964 in Beirut, Lebanon. He is the son of Patricia Taylor, a showgirl and costume designer, and Samuel Nowlin Reeves, a geologist. Keanu's father was born in Hawaii, of British, Portuguese, Native Hawaiian, and Chinese...",
                      actorInfo: ActorInfo.generate1(),
                      filmography: [Filmography(title: "John Wick: Chapter 4 ", year: "2021"),
                                    Filmography(title: "Bill & Ted Face the Music ", year: "2020"),
                                    Filmography(title: "Toy Story 4", year: "2019"),
                                    Filmography(title: "John Wick: Chapter 3 - Parabellum", year: "2019"),
                                    Filmography(title: "Replicas ", year: "2018")]),

                Actor(photo: R.image.actor2(),
                      name: "Halle Berry",
                      role: "Sofia",
                      age: "54",
                      bio: "born Maria Halle Berry August 14, 1966 - is an American actress. She began her career as a model and entered several beauty contests, finishing as the first runner-up in the Miss USA pageant and coming in sixth in the Miss World 1986. Her breakthrough film role was in the romantic comedy Boomerang (1992), alongside Eddie Murphy, which led to roles in films, such as the family comedy The Flintstones (1994), the political comedy-drama Bulworth (1998) and the television film Introducing Dorothy Dandridge (1999), for which she won a Primetime Emmy Award and a Golden Globe Award.",
                      actorInfo: ActorInfo.generate2(),
                      filmography: [Filmography(title: "John Wick: Chapter 3 – Parabellum", year: "2019"),
                                    Filmography(title: "Movie 43", year: "2013"),
                                    Filmography(title: "Kingsman: The Golden Circle", year: "2017"),
                                    Filmography(title: "Gothika", year: "2003"),
                                    Filmography(title: "Die Another Day ", year: "2002")]),

                Actor(photo: R.image.actor3(),
                      name: "Chad Stahelski",
                      role: "Director",
                      age: "52",
                      bio: "He came from a kick-boxing background; he entered the film field as a stunt performer at the age of 24. Before that, he worked as an instructor at the Inosanto Martial Arts Academy in California, teaching Jeet Kune Do/Jun Fan. After doing numerous roles in low budget martial art movies like Mission of Justice (1992) and Bloodsport III (1996) his first start as a stunt double came from the movie The Crow (1994) for doubling late Brandon Lee whom he trained with at the Inosanto Academy. After Brandon Lee's lethal accident Chad was picked for his stunt/photo double because he knew Lee, how he moved, and looked more like him than any other stuntman.",
                      actorInfo: ActorInfo.generate3(),
                      filmography: [Filmography(title: "Deadpool 2", year: "2018"),
                                    Filmography(title: "The Hunger Games: Catching Fire", year: "2013"),
                                    Filmography(title: "RED 2", year: "2013"),
                                    Filmography(title: "The Hunger Games", year: "2012"),
                                    Filmography(title: "Faster ", year: "2010")])
        ]
    }
}

class Info {
    let title: String?
    let value: String?

    init(title: String?, value: String?) {
        self.title = title
        self.value = value
    }
}

class ActorInfo: Info {
    static func generate1() -> [ActorInfo] {
        return [ActorInfo(title: NSLocalizedString("Birth Name", comment: ""), value: "Keanu Charles Reeves"),
                ActorInfo(title: NSLocalizedString("Career", comment: ""), value: "Actor, Producer"),
                ActorInfo(title: NSLocalizedString("Born", comment: ""), value: "September 2, 1964 in Beirut, Lebanon"),
                ActorInfo(title: NSLocalizedString("Nicknames", comment: ""), value: "The Wall, The One"),
                ActorInfo(title: NSLocalizedString("Height", comment: ""), value: "6' 1 (1.86 m)")]
    }
    static func generate2() -> [ActorInfo] {
        return [ActorInfo(title: NSLocalizedString("Birth Name", comment: ""), value: "Halle Berry"),
                ActorInfo(title: NSLocalizedString("Career", comment: ""), value: "Actor, Producer"),
                ActorInfo(title: NSLocalizedString("Born", comment: ""), value: "August 14, 1966"),
                ActorInfo(title: NSLocalizedString("Nicknames", comment: ""), value: "The Wall, The One"),
                ActorInfo(title: NSLocalizedString("Height", comment: ""), value: "6' 1 (1.70 m)")]
    }
    static func generate3() -> [ActorInfo] {
        return [ActorInfo(title: NSLocalizedString("Birth Name", comment: ""), value: "Charles F. Stahelski"),
                ActorInfo(title: NSLocalizedString("Career", comment: ""), value: "Actor, Producer"),
                ActorInfo(title: NSLocalizedString("Born", comment: ""), value: "September 20, 1968 in USA"),
                ActorInfo(title: NSLocalizedString("Nicknames", comment: ""), value: "The Wall, The One"),
                ActorInfo(title: NSLocalizedString("Height", comment: ""), value: "6' 1 (1.85 m)")]
    }
}

struct Filmography {
    let title: String?
    let year: String?
}

struct Trailer {
    let image: UIImage?
    let url: String?
    let title: String?
}

struct Photo {
    let image: UIImage?
}

struct Cinema {
    let name: String?
    let hallName1: String?
    let hallName2: String?
    let address: String?
    let time1: [SeanceTime]
    let time2: [SeanceTime]
}

struct SeanceTime {
    let time: String

    static func generate1() -> [SeanceTime] {

        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        timeFormatter.string(from: Date())

        return [SeanceTime(time: "11:00 AM"),
                SeanceTime(time: "1:50 PM"),
                SeanceTime(time: "4:40 PM"),
                SeanceTime(time: "7:30 PM"),
                SeanceTime(time: "9:30 PM")]
    }

    static func generate2() -> [SeanceTime] {
        return [SeanceTime(time: "9:00 AM"),
                SeanceTime(time: "11:00 AM"),
                SeanceTime(time: "1:50 PM"),
                SeanceTime(time: "4:40 PM"),
                SeanceTime(time: "7:30 PM"),
                SeanceTime(time: "9:30 PM")]
    }

}

class MovieList: NSObject {
    let items: [MovieItem]

    init(items: [MovieItem]) {
        self.items = items
        super.init()
    }
}

extension MovieList {
    static func generate() -> MovieList {
        return MovieList(items: [

            MovieItem(title: NSLocalizedString("John Wick: Chapter 3", comment: ""),
                      image: R.image.cover1(),
                      midImage: R.image.coverMid1(),
                      imdb: "8.4",
                      genre: "Action, Crime, Thriller",
                      info: "USA, 2019  /  2h 10min  /  PG-16",
                      story: "In this third installment of the adrenaline-fueled action franchise, super-assassin John Wick (Keanu Reeves) returns with a $14 million price tag on his head and an army of bounty-hunting killers on his trail. After killing a member of the shadowy international assassin’s guild, the High Table, John Wick is excommunicado, but the world’s most ruthless hit men and women await his every turn.",
                      actor: Actor.generate(),
                      trailer: [Trailer(image: R.image.trailer1(), url: "", title: "Exlusive Trailer"), Trailer(image: R.image.trailer1(), url: "", title: "Official Trailer")],
                      photo: [Photo(image: R.image.photo1()), Photo(image: R.image.photo2()), Photo(image: R.image.photo1())],
                      cinema: [Cinema(name: "AMC Lincoln Square 13",
                                      hallName1: "Hall #1 2D",
                                      hallName2: "Hall #2 3D",
                                      address: "1998 Broadway, New York, New York 10023",
                                      time1: SeanceTime.generate1(),
                                      time2: SeanceTime.generate2()),
                               Cinema(name: "AMC 84th Street 6",
                                      hallName1: "Hall #1 2D",
                                      hallName2: "Hall #2 3D",
                                      address: "2310 Broadway, New York, New York 10024",
                                      time1: SeanceTime.generate1(),
                                      time2: SeanceTime.generate2())], hasDetails: true),

            MovieItem(title: NSLocalizedString("Spider-Man", comment: ""),
                      image: R.image.cover2(),
                      midImage: R.image.coverMid2(),
                      imdb: "7.4",
                      genre: "Action2, Crime, Thriller",
                      info: "USA, 2019  /  2h 10min  /  PG-16",
                      story: "In this third installment of the adrenaline-fueled action franchise, super-assassin John Wick (Keanu Reeves) returns with a $14 million price tag on his head and an army of bounty-hunting killers on his trail. After killing a member of the shadowy international assassin’s guild, the High Table, John Wick is excommunicado, but the world’s most ruthless hit men and women await his every turn.",
                      actor: Actor.generate(),
                      trailer: [Trailer(image: R.image.trailer1(), url: "", title: "Exlusive Trailer")],
                      photo: [Photo(image: R.image.photo1()), Photo(image: R.image.photo2()), Photo(image: R.image.photo1())],
                      cinema: [Cinema(name: "AMC Lincoln Square 13",
                                      hallName1: "Hall #1 2D",
                                      hallName2: "Hall #2 3D",
                                      address: "1998 Broadway, New York, New York 10023",
                                      time1: SeanceTime.generate1(),
                                      time2: SeanceTime.generate2()),
                               Cinema(name: "AMC 84th Street 6",
                                      hallName1: "Hall #1 2D",
                                      hallName2: "Hall #2 3D",
                                      address: "2310 Broadway, New York, New York 10024",
                                      time1: SeanceTime.generate1(),
                                      time2: SeanceTime.generate2())], hasDetails: false),

            MovieItem(title: NSLocalizedString("Godzilla", comment: ""),
                      image: R.image.cover3(),
                      midImage: R.image.coverMid3(),
                      imdb: "5.4",
                      genre: "Action3, Crime, Thriller",
                      info: "USA, 2019  /  2h 10min  /  PG-16",
                      story: "In this third installment of the adrenaline-fueled action franchise, super-assassin John Wick (Keanu Reeves) returns with a $14 million price tag on his head and an army of bounty-hunting killers on his trail. After killing a member of the shadowy international assassin’s guild, the High Table, John Wick is excommunicado, but the world’s most ruthless hit men and women await his every turn.",
                      actor: Actor.generate(),
                      trailer: [Trailer(image: R.image.trailer1(), url: "", title: "Exlusive Trailer")],
                      photo: [Photo(image: R.image.photo1()), Photo(image: R.image.photo2()), Photo(image: R.image.photo1())],
                      cinema: [Cinema(name: "AMC Lincoln Square 13",
                                      hallName1: "Hall #1 2D",
                                      hallName2: "Hall #2 3D",
                                      address: "1998 Broadway, New York, New York 10023",
                                      time1: SeanceTime.generate1(),
                                      time2: SeanceTime.generate2()),
                               Cinema(name: "AMC 84th Street 6",
                                      hallName1: "Hall #1 2D",
                                      hallName2: "Hall #2 3D",
                                      address: "2310 Broadway, New York, New York 10024",
                                      time1: SeanceTime.generate1(),
                                      time2: SeanceTime.generate2())], hasDetails: false),

            MovieItem(title: NSLocalizedString("Dark Phoenix", comment: ""),
                      image: R.image.cover4(),
                      midImage: R.image.coverMid4(),
                      imdb: "5.5",
                      genre: "Action4, Crime, Thriller",
                      info: "USA, 2019  /  2h 10min  /  PG-16",
                      story: "In this third installment of the adrenaline-fueled action franchise, super-assassin John Wick (Keanu Reeves) returns with a $14 million price tag on his head and an army of bounty-hunting killers on his trail. After killing a member of the shadowy international assassin’s guild, the High Table, John Wick is excommunicado, but the world’s most ruthless hit men and women await his every turn.",
                      actor: Actor.generate(),
                      trailer: [Trailer(image: R.image.trailer1(), url: "", title: "Exlusive Trailer")],
                      photo: [Photo(image: R.image.photo1()), Photo(image: R.image.photo2()), Photo(image: R.image.photo1())],
                      cinema: [Cinema(name: "AMC Lincoln Square 13",
                                      hallName1: "Hall #1 2D",
                                      hallName2: "Hall #2 3D",
                                      address: "1998 Broadway, New York, New York 10023",
                                      time1: SeanceTime.generate1(),
                                      time2: SeanceTime.generate2()),
                               Cinema(name: "AMC 84th Street 6",
                                      hallName1: "Hall #1 2D",
                                      hallName2: "Hall #2 3D",
                                      address: "2310 Broadway, New York, New York 10024",
                                      time1: SeanceTime.generate1(),
                                      time2: SeanceTime.generate2())], hasDetails: false),

            MovieItem(title: NSLocalizedString("It: Chapter Two", comment: ""),
                      image: R.image.cover5(),
                      midImage: R.image.coverMid5(),
                      imdb: "8.4",
                      genre: "Action, Crime, Thriller",
                      info: "USA, 2019  /  2h 10min  /  PG-16",
                      story: "In this third installment of the adrenaline-fueled action franchise, super-assassin John Wick (Keanu Reeves) returns with a $14 million price tag on his head and an army of bounty-hunting killers on his trail. After killing a member of the shadowy international assassin’s guild, the High Table, John Wick is excommunicado, but the world’s most ruthless hit men and women await his every turn.",
                      actor: Actor.generate(),
                      trailer: [Trailer(image: R.image.trailer1(), url: "", title: "Exlusive Trailer")],
                      photo: [Photo(image: R.image.photo1()), Photo(image: R.image.photo2()), Photo(image: R.image.photo1())],
                      cinema: [Cinema(name: "AMC Lincoln Square 13",
                                      hallName1: "Hall #1 2D",
                                      hallName2: "Hall #2 3D",
                                      address: "1998 Broadway, New York, New York 10023",
                                      time1: SeanceTime.generate1(),
                                      time2: SeanceTime.generate2()),
                               Cinema(name: "AMC 84th Street 6",
                                      hallName1: "Hall #1 2D",
                                      hallName2: "Hall #2 3D",
                                      address: "2310 Broadway, New York, New York 10024",
                                      time1: SeanceTime.generate1(),
                                      time2: SeanceTime.generate2())], hasDetails: false),

            MovieItem(title: NSLocalizedString("Once Upon a Time in Hollywood", comment: ""),
                      image: R.image.cover6(),
                      midImage: R.image.coverMid6(),
                      imdb: "7.4",
                      genre: "Action, Crime, Thriller",
                      info: "USA, 2019  /  2h 10min  /  PG-16",
                      story: "In this third installment of the adrenaline-fueled action franchise, super-assassin John Wick (Keanu Reeves) returns with a $14 million price tag on his head and an army of bounty-hunting killers on his trail. After killing a member of the shadowy international assassin’s guild, the High Table, John Wick is excommunicado, but the world’s most ruthless hit men and women await his every turn.",
                      actor: Actor.generate(),
                      trailer: [Trailer(image: R.image.trailer1(), url: "", title: "Exlusive Trailer")],
                      photo: [Photo(image: R.image.photo1()), Photo(image: R.image.photo2()), Photo(image: R.image.photo1())],
                      cinema: [Cinema(name: "AMC Lincoln Square 13",
                                      hallName1: "Hall #1 2D",
                                      hallName2: "Hall #2 3D",
                                      address: "1998 Broadway, New York, New York 10023",
                                      time1: SeanceTime.generate1(),
                                      time2: SeanceTime.generate2()),
                               Cinema(name: "AMC 84th Street 6",
                                      hallName1: "Hall #1 2D",
                                      hallName2: "Hall #2 3D",
                                      address: "2310 Broadway, New York, New York 10024",
                                      time1: SeanceTime.generate1(),
                                      time2: SeanceTime.generate2())], hasDetails: false)

        ])
    }
}
