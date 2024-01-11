@react.component
let make = () => {
  let keyword = QueryParams.useQueryParams()->Js.Dict.get("q")
  let (searchText, setSearchText) = React.useState(() => keyword)

  let onSearchInputChange = event => {
    let value = ReactEvent.Form.target(event)["value"]
    setSearchText(_ => value)
  }

  let handleSearchSubmit = event => {
    event->ReactEvent.Form.preventDefault
    switch searchText {
    | Some(value) => RescriptReactRouter.push(`/?q=${value}`)
    | None => ()
    }
  }

  <header className={`flex justify-center my-4`}>
    <form onSubmit={handleSearchSubmit}>
      <div className="border border-gray-300 rounded-md p-2 flex justify-between items-center w-96">
        <input
          placeholder="저장소를 검색하세요"
          onChange={onSearchInputChange}
          value={searchText->Option.getOr("")}
        />
        <button> {"검색"->React.string} </button>
      </div>
    </form>
  </header>
}
