// base implementation
package zentasktic_core

import (
	"strconv"
	"errors"
)


type Collection struct {
	Id 			string `json:"collectionId"`
	Name 		string `json:"collectionName"`
}


// collections

func (Collection c) AddCollection() (err error) {
	// implementation
}

func (Collection c) AddProjectToCollection(p Project) (err error) {
	// implementation
}

func (Collection c) AddTaskToCollection(t Task) (err error) {
	// implementation
}

func (Collection c) RemoveProjectFromCollection(p Project) (err error) {
	// implementation
}

func (Collection c) RemoveTaskFromCollection(p Project) (err error) {
	// implementation
}

func (Collection c) DeleteCollection() (err error) {
	// implementation
}