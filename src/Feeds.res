module FeedsQuery = %relay(`
  query FeedsQuery($query: String!) {
    ...SearchResultsFragment @arguments(query: $query)
  }
`)

@react.component
let make = (~query, ~fetchKey) => {
  let data = FeedsQuery.use(~variables={query: query}, ~fetchKey)

  <>
    <React.Suspense fallback={<div> {"Loading..."->React.string} </div>}>
      <SearchResults search={data.fragmentRefs} />
    </React.Suspense>
  </>
}
