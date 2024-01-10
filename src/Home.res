@scope(("window", "history")) @val
external pushState: (Js.Dict.t<'a>, string, string) => unit = "pushState"

module FeedsQuery = %relay(`
  query HomeQuery($query: String!) {
    ...SearchResultsFragment @arguments(query: $query)
  }
`)

@react.component
let make = () => {
  let url = QueryParams.useQueryParams()
  let query = switch url->Js.Dict.get("q") {
  | Some(q) => q
  | None => ""
  }
  //선언적으로 처리하면 transition 적용 안됨?
  let data = FeedsQuery.use(
    ~variables={query: query},
    ~fetchPolicy=switch query {
    | "" => StoreOnly
    // store부터 확인, 없으면 network request
    | _ => StoreOrNetwork
    },
  )
  let (searchText, setSearchText) = React.useState(() => "")

  let onSearchInputChange = event => {
    let value = ReactEvent.Form.target(event)["value"]
    setSearchText(_ => value)
  }

  let handleSearchSubmit = event => {
    event->ReactEvent.Form.preventDefault
    RescriptReactRouter.push(`/?q=${searchText}`)
  }

  <>
    <FeedsHeader
      handleSearchSubmit={handleSearchSubmit}
      onSearchInputChange={onSearchInputChange}
      searchText={searchText}
    />
    <React.Suspense fallback={<div> {"Loading..."->React.string} </div>}>
      <RescriptReactErrorBoundary
        fallback={_err => <div> {"An error occurred"->React.string} </div>}>
        <SearchResults search={data.fragmentRefs} />
      </RescriptReactErrorBoundary>
    </React.Suspense>
  </>
}
