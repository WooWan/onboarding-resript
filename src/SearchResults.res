module Fragment = %relay(`
    fragment SearchResultsFragment on Query
    @refetchable(queryName: "SearchQeuery")
    @argumentDefinitions(
      query: { type: "String", defaultValue: "" }
      count: { type: "Int", defaultValue: 5 }
      cursor: { type: "String" }
    ) {
      search(query: $query, first: $count, type: REPOSITORY, after: $cursor)
        @connection(key: "Repos_search") {
        repositoryCount
        pageInfo {
          hasNextPage
        }
        edges {
          cursor
          node {
            ...RepositoryFragment
          }
        }
      }
    }
`)

@react.component
let make = (~search) => {
  let {data, loadNext, isLoadingNext} = Fragment.usePagination(search)
  let repositories = data.search->Fragment.getConnectionNodes
  let hasNextPage = data.search.pageInfo.hasNextPage
  let (isPending, startTransition) = ReactExperimental.useTransition()

  let onLoadMore = () =>
    startTransition(() => {
      loadNext(~count=3)->ignore
    })

  <div className="flex flex-col">
    {switch repositories->Belt.Array.length > 0 {
    | false => "검색 결과가 없습니다."->React.string
    | true =>
      repositories
      ->Belt.Array.mapWithIndex((index, repo) =>
        <Repository key={index->Int.toString} isPending={isPending} repository=repo.fragmentRefs />
      )
      ->React.array
    }}
    {switch hasNextPage {
    | true =>
      <button disabled=isLoadingNext onClick={_ => onLoadMore()}>
        {switch isLoadingNext {
        | true => "로딩중..."->React.string
        | false => "더보기"->React.string
        }}
      </button>
    | false => React.null
    }}
  </div>
}
