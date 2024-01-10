module Fragment = %relay(`
  fragment StarButtonFragment on Repository {
    id @required(action: NONE)
    viewerHasStarred @required(action: NONE)
    stargazers @required(action: NONE) {
      totalCount
    }
  }
`)

module RepositoryStarMutation = %relay(`
  mutation StarButtonStarMutation($input: AddStarInput!) @raw_response_type {
    addStar(input: $input) {
      starrable {
        viewerHasStarred
        stargazers {
          totalCount
        }
      }
    }
  }
`)

module RepositoryUnstarMutation = %relay(`
  mutation StarButtonUnstarMutation($input: RemoveStarInput!) @raw_response_type {
    removeStar(input: $input) {
      starrable {
        viewerHasStarred
        stargazers {
          totalCount
        }
      }
    }
  }
`)

@react.component
let make = (~star) => {
  let data = Fragment.use(star)
  let (starMutation, _) = RepositoryStarMutation.use()
  let (unstarMutation, _) = RepositoryUnstarMutation.use()

  <>
    {switch data {
    | None => "Loading..."->React.string
    | Some(data) => {
        let toggleStar = () => {
          if data.viewerHasStarred {
            let input: StarButtonUnstarMutation_graphql.Types.variables = {
              input: {
                starrableId: data.id,
                clientMutationId: "",
              },
            }

            unstarMutation(
              ~variables={input},
              ~optimisticResponse={
                removeStar: Some({
                  starrable: Some({
                    __typename: "Repository",
                    id: data.id,
                    viewerHasStarred: false,
                    stargazers: {
                      totalCount: data.stargazers.totalCount - 1,
                    },
                  }),
                }),
              },
            )->RescriptRelay.Disposable.ignore
          } else {
            let input: StarButtonStarMutation_graphql.Types.variables = {
              input: {
                starrableId: data.id,
                clientMutationId: "",
              },
            }
            starMutation(
              ~variables={input},
              ~optimisticResponse={
                addStar: Some({
                  starrable: Some({
                    __typename: "Repository",
                    id: data.id,
                    viewerHasStarred: true,
                    stargazers: {
                      totalCount: data.stargazers.totalCount + 1,
                    },
                  }),
                }),
              },
            )->RescriptRelay.Disposable.ignore
          }
        }

        <div>
          <button onClick={_ => toggleStar()}>
            {switch data.viewerHasStarred {
            | true => "⭐️"->React.string
            | false => "Unstar"->React.string
            }}
          </button>
          <p> {data.stargazers.totalCount->React.int} </p>
        </div>
      }
    }}
  </>
}
