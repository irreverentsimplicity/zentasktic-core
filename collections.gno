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

// actions

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

// getters

func () GetCollections(string realmId) (collections string, err error) {
	// implementation
}

func () GetCollectionById(string collectionId) (collection string, err error) {
	// implementation
}