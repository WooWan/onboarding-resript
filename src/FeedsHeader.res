@react.component
let make = (~searchText, ~handleSearchSubmit, ~onSearchInputChange) => {
  <header className={`flex justify-center my-4`}>
    <form onSubmit={handleSearchSubmit}>
      <div className="border border-gray-300 rounded-md p-2 flex justify-between items-center w-96">
        <input
          placeholder="저장소를 검색하세요"
          onChange={onSearchInputChange}
          value={searchText}
        />
        <button> {"검색"->React.string} </button>
      </div>
    </form>
  </header>
}