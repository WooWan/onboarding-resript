module FeedsQuery = %relay(`
  query FeedsQuery($query: String!) {
    ...SearchResultsFragment @arguments(query: $query)
  }
`)

@react.component
let make = (~query) => {
  let data = FeedsQuery.use(~variables={query: query})

  <>
    <React.Suspense fallback={<div> {"Loading..."->React.string} </div>}>
      <RescriptReactErrorBoundary
        fallback={_err => <div> {"An error occurred"->React.string} </div>}>
        <SearchResults search={data.fragmentRefs} />
      </RescriptReactErrorBoundary>
    </React.Suspense>
  </>
}
