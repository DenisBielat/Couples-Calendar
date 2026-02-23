import Foundation

struct MockDateCompositions {
    static let all: [DateComposition] = featured + tonight

    static let featured: [DateComposition] = [
        // 1. Cubs Game Day (sports)
        DateComposition(
            id: "mc1",
            title: "Cubs Game Day",
            subtitle: "Wrigley Field \u{00B7} Saturday",
            category: .sports,
            steps: [
                DateStep(
                    id: "mc1s1", order: 1, role: .before,
                    title: "Pre-game beers at Murphy's Bleachers",
                    description: "Kick off game day at the legendary sports bar across from Wrigley",
                    venueName: "Murphy's Bleachers",
                    venueAddress: "3655 N Sheffield Ave, Chicago",
                    time: "11:00 AM", durationMinutes: 90,
                    externalURL: nil, placeId: nil, imageURL: nil
                ),
                DateStep(
                    id: "mc1s2", order: 2, role: .main,
                    title: "Cubs vs Cardinals at Wrigley Field",
                    description: "Catch America's favorite pastime at the iconic ballpark",
                    venueName: "Wrigley Field",
                    venueAddress: "1060 W Addison St, Chicago",
                    time: "1:20 PM", durationMinutes: 180,
                    externalURL: nil, placeId: nil, imageURL: nil
                ),
                DateStep(
                    id: "mc1s3", order: 3, role: .after,
                    title: "Post-game fun at Sluggers",
                    description: "Hit the batting cages and celebrate (or commiserate) upstairs",
                    venueName: "Sluggers World Class Sports Bar",
                    venueAddress: "3540 N Clark St, Chicago",
                    time: "5:00 PM", durationMinutes: 90,
                    externalURL: nil, placeId: nil, imageURL: nil
                )
            ],
            estimatedCost: CostEstimate(level: .moderate, min: 80, max: 150, note: "Tickets + food & drinks"),
            dateCoins: 15,
            imageURL: nil,
            tags: ["sports", "baseball", "wrigleyville", "classic"],
            source: .composed,
            anchorEventId: nil
        ),

        // 2. Jazz Under the Stars (concerts)
        DateComposition(
            id: "mc2",
            title: "Jazz Night Out",
            subtitle: "Millennium Park \u{00B7} This Friday",
            category: .concerts,
            steps: [
                DateStep(
                    id: "mc2s1", order: 1, role: .before,
                    title: "Craft cocktails at The Signature Room",
                    description: "Sip drinks with a stunning skyline view",
                    venueName: "The Signature Room",
                    venueAddress: "875 N Michigan Ave, Chicago",
                    time: "5:30 PM", durationMinutes: 60,
                    externalURL: nil, placeId: nil, imageURL: nil
                ),
                DateStep(
                    id: "mc2s2", order: 2, role: .main,
                    title: "Jazz Under the Stars at Millennium Park",
                    description: "An enchanting evening of live jazz in the open air",
                    venueName: "Millennium Park",
                    venueAddress: "201 E Randolph St, Chicago",
                    time: "7:00 PM", durationMinutes: 120,
                    externalURL: nil, placeId: nil, imageURL: nil
                ),
                DateStep(
                    id: "mc2s3", order: 3, role: .after,
                    title: "Late-night bites at Portillo's",
                    description: "Cap the night with Chicago-style hot dogs",
                    venueName: "Portillo's",
                    venueAddress: "100 W Ontario St, Chicago",
                    time: "9:30 PM", durationMinutes: 45,
                    externalURL: nil, placeId: nil, imageURL: nil
                )
            ],
            estimatedCost: CostEstimate(level: .moderate, min: 60, max: 100, note: "Drinks + food (concert may be free)"),
            dateCoins: 12,
            imageURL: nil,
            tags: ["music", "jazz", "romantic", "outdoors"],
            source: .composed,
            anchorEventId: nil
        ),

        // 3. Comedy Date Night
        DateComposition(
            id: "mc3",
            title: "Comedy Date Night",
            subtitle: "The Laugh Factory \u{00B7} Tomorrow",
            category: .comedy,
            steps: [
                DateStep(
                    id: "mc3s1", order: 1, role: .before,
                    title: "Dinner at Quartino Ristorante",
                    description: "Shared plates and wine to set the mood",
                    venueName: "Quartino Ristorante",
                    venueAddress: "626 N State St, Chicago",
                    time: "6:00 PM", durationMinutes: 75,
                    externalURL: nil, placeId: nil, imageURL: nil
                ),
                DateStep(
                    id: "mc3s2", order: 2, role: .main,
                    title: "Live Comedy at The Laugh Factory",
                    description: "Top comedians perform their best material",
                    venueName: "The Laugh Factory",
                    venueAddress: "3175 N Broadway, Chicago",
                    time: "8:30 PM", durationMinutes: 90,
                    externalURL: nil, placeId: nil, imageURL: nil
                ),
                DateStep(
                    id: "mc3s3", order: 3, role: .after,
                    title: "Dessert at Ghirardelli",
                    description: "End with something sweet",
                    venueName: "Ghirardelli Ice Cream & Chocolate Shop",
                    venueAddress: "830 N Michigan Ave, Chicago",
                    time: "10:30 PM", durationMinutes: 30,
                    externalURL: nil, placeId: nil, imageURL: nil
                )
            ],
            estimatedCost: CostEstimate(level: .moderate, min: 70, max: 120, note: "Dinner + tickets + dessert"),
            dateCoins: 12,
            imageURL: nil,
            tags: ["comedy", "laughs", "dinner", "nightlife"],
            source: .composed,
            anchorEventId: nil
        ),

        // 4. Weekend Foodie Adventure (food)
        DateComposition(
            id: "mc4",
            title: "Weekend Foodie Adventure",
            subtitle: "Logan Square \u{00B7} This Saturday",
            category: .food,
            steps: [
                DateStep(
                    id: "mc4s1", order: 1, role: .before,
                    title: "Farmers market browsing at Logan Square",
                    description: "Pick up fresh ingredients and artisan goods together",
                    venueName: "Logan Square Farmers Market",
                    venueAddress: "3107 W Logan Blvd, Chicago",
                    time: "10:00 AM", durationMinutes: 60,
                    externalURL: nil, placeId: nil, imageURL: nil
                ),
                DateStep(
                    id: "mc4s2", order: 2, role: .main,
                    title: "Cooking class at The Chopping Block",
                    description: "Learn to cook a seasonal meal together with a pro chef",
                    venueName: "The Chopping Block",
                    venueAddress: "4747 N Lincoln Ave, Chicago",
                    time: "12:00 PM", durationMinutes: 120,
                    externalURL: nil, placeId: nil, imageURL: nil
                ),
                DateStep(
                    id: "mc4s3", order: 3, role: .after,
                    title: "Gelato walk on Armitage Ave",
                    description: "Stroll and enjoy gelato from a local shop",
                    venueName: "Black Dog Gelato",
                    venueAddress: "859 N Damen Ave, Chicago",
                    time: "2:30 PM", durationMinutes: 45,
                    externalURL: nil, placeId: nil, imageURL: nil
                )
            ],
            estimatedCost: CostEstimate(level: .moderate, min: 50, max: 100, note: "Market + class + treats"),
            dateCoins: 15,
            imageURL: nil,
            tags: ["food", "cooking", "farmers market", "adventure"],
            source: .curated,
            anchorEventId: nil
        ),

        // 5. Cozy Movie Night (movies)
        DateComposition(
            id: "mc5",
            title: "Cozy Movie Night",
            subtitle: "AMC River East \u{00B7} This Weekend",
            category: .movies,
            steps: [
                DateStep(
                    id: "mc5s1", order: 1, role: .before,
                    title: "Dinner at Giordano's",
                    description: "Deep dish pizza before the show",
                    venueName: "Giordano's",
                    venueAddress: "730 N Rush St, Chicago",
                    time: "5:30 PM", durationMinutes: 60,
                    externalURL: nil, placeId: nil, imageURL: nil
                ),
                DateStep(
                    id: "mc5s2", order: 2, role: .main,
                    title: "Movie at AMC River East 21",
                    description: "Catch the latest blockbuster in recliner seats",
                    venueName: "AMC River East 21",
                    venueAddress: "322 E Illinois St, Chicago",
                    time: "7:00 PM", durationMinutes: 135,
                    externalURL: nil, placeId: nil, imageURL: nil
                ),
                DateStep(
                    id: "mc5s3", order: 3, role: .after,
                    title: "Nightcap at The Aviary",
                    description: "Award-winning cocktails in an intimate setting",
                    venueName: "The Aviary",
                    venueAddress: "955 W Fulton Market, Chicago",
                    time: "9:30 PM", durationMinutes: 60,
                    externalURL: nil, placeId: nil, imageURL: nil
                )
            ],
            estimatedCost: CostEstimate(level: .upscale, min: 90, max: 160, note: "Dinner + tickets + cocktails"),
            dateCoins: 10,
            imageURL: nil,
            tags: ["movies", "dinner", "cocktails", "cozy"],
            source: .composed,
            anchorEventId: nil
        )
    ]

    static let tonight: [DateComposition] = [
        DateComposition(
            id: "mt1",
            title: "Spontaneous Jazz & Bites",
            subtitle: "Green Mill \u{00B7} Tonight",
            category: .concerts,
            steps: [
                DateStep(
                    id: "mt1s1", order: 1, role: .main,
                    title: "Live jazz at Green Mill Cocktail Lounge",
                    description: "Chicago's legendary jazz club since 1907",
                    venueName: "Green Mill Cocktail Lounge",
                    venueAddress: "4802 N Broadway, Chicago",
                    time: "8:00 PM", durationMinutes: 120,
                    externalURL: nil, placeId: nil, imageURL: nil
                ),
                DateStep(
                    id: "mt1s2", order: 2, role: .after,
                    title: "Late-night tacos at Big Star",
                    description: "Whiskey and tacos to close out the night",
                    venueName: "Big Star",
                    venueAddress: "1531 N Damen Ave, Chicago",
                    time: "10:30 PM", durationMinutes: 45,
                    externalURL: nil, placeId: nil, imageURL: nil
                )
            ],
            estimatedCost: CostEstimate(level: .budget, min: 20, max: 50, note: "Cover + drinks & tacos"),
            dateCoins: 8,
            imageURL: nil,
            tags: ["jazz", "spontaneous", "nightlife"],
            source: .curated,
            anchorEventId: nil
        ),
        DateComposition(
            id: "mt2",
            title: "Night Market Date",
            subtitle: "Downtown Square \u{00B7} Tonight",
            category: .food,
            steps: [
                DateStep(
                    id: "mt2s1", order: 1, role: .main,
                    title: "Explore the Night Market",
                    description: "Street food, live music, and local vendors",
                    venueName: "Downtown Square",
                    venueAddress: "Downtown, Chicago",
                    time: "6:00 PM", durationMinutes: 120,
                    externalURL: nil, placeId: nil, imageURL: nil
                ),
                DateStep(
                    id: "mt2s2", order: 2, role: .after,
                    title: "Rooftop drinks at Cindy's",
                    description: "End the night with views of Millennium Park",
                    venueName: "Cindy's Rooftop",
                    venueAddress: "12 S Michigan Ave, Chicago",
                    time: "8:30 PM", durationMinutes: 60,
                    externalURL: nil, placeId: nil, imageURL: nil
                )
            ],
            estimatedCost: CostEstimate(level: .budget, min: 25, max: 60, note: "Street food + drinks"),
            dateCoins: 8,
            imageURL: nil,
            tags: ["food", "market", "rooftop", "spontaneous"],
            source: .curated,
            anchorEventId: nil
        )
    ]
}
