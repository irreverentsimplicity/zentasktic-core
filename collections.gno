// base implementation
package zentasktic

import (
	"strconv"
	"errors"

	"gno.land/p/demo/avl"
)


type Collection struct {
	Id 			string `json:"collectionId"`
	RealmId 	string `json:"collectionRealmId"`
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

func (c Collection) AddCollection() (err error) {
	// implementation
	if Collections.Size() != 0 {
		existingCollection, exist := Collections.Get(c.Id)
		if exist {
			return ErrCollectionIdAlreadyExists
		}
	}
	Collections.Set(c.Id, c)
	return nil
}

func (c Collection) EditCollection() (err error) {
	// implementation
	if Collections.Size() != 0 {
		existingCollection, exist := Collections.Get(c.Id)
		if !exist {
			return ErrCollectionIdNotFound
		}
	}
	
	Collections.Set(c.Id, c)
	return nil
}

func (c Collection) RemoveCollection() (err error) {
	// implementation
	collection := Collection{}
	if Collections.Size() != 0 {
		collection, exist := Collections.Get(c.Id)
		if !exist {
			return ErrCollectionIdNotFound
		}
	}

	_, removed := Collections.Remove(collection.(Collection).Id)
	if !removed {
		return ErrCollectionNotRemoved
	}
	return nil
}

/*
func (c Collection) AddProjectToCollection(p Project) (err error) {
	// implementation
}

func (c Collection) AddTaskToCollection(t Task) (err error) {
	// implementation
}

func (c Collection) RemoveProjectFromCollection(p Project) (err error) {
	// implementation
}

func (c Collection) RemoveTaskFromCollection(p Project) (err error) {
	// implementation
}



// getters

func () GetCollections(string realmId) (collections string, err error) {
	// implementation
} */

func GetCollectionById(collectionId string) (c Collection, err error) {
	// implementation
	if Collections.Size() != 0 {
		c, exist := Collections.Get(collectionId)
		if exist {
			return c.(Collection), nil
		} else {
			return nil, ErrCollectionByIdNotFound
		}
	}
}