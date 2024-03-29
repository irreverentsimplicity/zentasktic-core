// base implementation
package zentasktic

import (
	"strconv"
	"errors"

	"gno.land/p/demo/avl"
)


type Collection struct {
	Id 			string `json:"collectionId"`
	Name 		string `json:"collectionName"`
	Tasks		[]Task `json:"collectionTasks"`
	Projects	[]Project `json:"collectionProjects"`
}

var (
	Collections avl.Tree // collectionId -> Collection
	CollectionTasks avl.Tree // CollectionId -> []Task
	CollectionProjects avl.Tree // CollectionID -> []Project
)

// actions
/*
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
}*/