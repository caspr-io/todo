import PropTypes from "prop-types";
import React from "react";
import Checkbox from "./checkbox";
import NewItem from "./newItem";

function Header({ filter, addItem, setFilter }) {
  const [adding, setAdding] = React.useState(false);

  const enableOverdueFilter = window['_appConfig_'].ENABLE_OVERDUE_FILTER === "true"
  const enableCompletedFilter = window['_appConfig_'].ENABLE_COMPLETED_FILTER === "true"

  const selectOverdueFilter = () => setFilter({ ...filter, overdueOnly: true });
  const unSelectOverdueFilter = () => setFilter({ ...filter, overdueOnly: false });
  const selectCompleteFilter = () => setFilter({ ...filter, includeComplete: true });
  const unSelectCompleteFilter = () => setFilter({ ...filter, includeComplete: false });

  const addNewItem = item => {
    setAdding(false);
    addItem(item);
  };

  return (
    <header>
      <nav className="navbar navbar-light bg-light">
        <span className="navbar-brand">Todo list</span>
        <div style={{ flexDirection: "inherit", display: "flex", alignItems: "center" }}>
          {!adding &&
            <button type="button" className="btn btn-link" onClick={() => setAdding(true)}>
              Add new item
            </button>
          }
          {enableOverdueFilter &&
            <Checkbox
              label="Overdue items only"
              selected={filter.overdueOnly}
              select={selectOverdueFilter}
              unSelect={unSelectOverdueFilter}
            />
          }
          {enableCompletedFilter &&
            <Checkbox
              label="Include complete items"
              selected={filter.includeComplete}
              select={selectCompleteFilter}
              unSeect={unSelectCompleteFilter}
            />
          }
        </div>
      </nav>
      {adding && <NewItem cancel={() => setAdding(false)} add={addNewItem} />}
    </header>
  );
}

Header.propTypes = {
  addItem: PropTypes.func.isRequired,
  filter: PropTypes.object.isRequired,
  setFilter: PropTypes.func.isRequired,
};

export default Header;
