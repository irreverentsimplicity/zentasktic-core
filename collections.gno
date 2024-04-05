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


func (c Collection) AddProjectToCollection(p Project) (err error) {
	// implementation
	if Collections.Size() != 0 {
		existingCollection, exist := Collections.Get(c.Id)
		if !exist {
			return ErrCollectionIdNotFound
		}
	}

	existingCollectionProjects, texist := CollectionProjects.Get(c.Id)
	if !texist {
		// If the collections has no projects yet, initialize the slice.
		existingCollectionProjects = []Project{}
	} else {
		projects, ok := existingCollectionProjects.([]Project)
		if !ok {
			return ErrCollectionsProjectsNotFound
		}
		existingCollectionProjects = projects
	}
	updatedProjects := append(existingCollectionProjects.([]Project), p)
	p.RealmId = "4"
	p.EditProject()
	CollectionProjects.Set(c.Id, updatedProjects)

	return nil
}

func (c Collection) AddTaskToCollection(t Task) (err error) {
	// implementation
	if Collections.Size() != 0 {
		existingCollection, exist := Collections.Get(c.Id)
		if !exist {
			return ErrCollectionIdNotFound
		}
	}

	existingCollectionTasks, texist := CollectionTasks.Get(c.Id)
	if !texist {
		// If the collections has no tasks yet, initialize the slice.
		existingCollectionTasks = []Task{}
	} else {
		tasks, ok := existingCollectionTasks.([]Task)
		if !ok {
			return ErrCollectionsTasksNotFound
		}
		existingCollectionTasks = tasks
	}
	updatedTasks := append(existingCollectionTasks.([]Task), t)
	t.RealmId = "4"
	t.EditTask()
	CollectionTasks.Set(c.Id, updatedTasks)

	return nil
}

func (c Collection) RemoveProjectFromCollection(p Project) (err error) {
	// implementation
	if Collections.Size() != 0 {
		existingCollection, exist := Collections.Get(c.Id)
		if !exist {
			return ErrCollectionIdNotFound
		}
	}

	existingCollectionProjects, texist := CollectionProjects.Get(c.Id)
	if !texist {
		// If the collection has no projects yet, return appropriate error
		return ErrCollectionsProjectsNotFound
	}

	// Find the index of the project to be removed.
	var index int = -1
	for i, project := range existingCollectionProjects.([]Project) {
		if project.Id == p.Id {
			index = i
			break
		}
	}

	// If the project was found, we remove it from the slice.
	if index != -1 {
		// by default we send it bacl to Assess
		p.RealmId = "1"
		p.EditProject()
		existingCollectionProjects = append(existingCollectionProjects.([]Project)[:index], existingCollectionProjects.([]Project)[index+1:]...)
	} else {
		// Project not found in the collection
		return ErrProjectByIdNotFound 
	}
	CollectionProjects.Set(c.Id, existingCollectionProjects)

	return nil
}

func (c Collection) RemoveTaskFromCollection(t Task) (err error) {
	// implementation
	if Collections.Size() != 0 {
		existingCollection, exist := Collections.Get(c.Id)
		if !exist {
			return ErrCollectionIdNotFound
		}
	}

	existingCollectionTasks, texist := CollectionTasks.Get(c.Id)
	if !texist {
		// If the collection has no tasks yet, return appropriate error
		return ErrCollectionsTasksNotFound
	}

	// Find the index of the task to be removed.
	var index int = -1
	for i, task := range existingCollectionTasks.([]Task) {
		if task.Id == t.Id {
			index = i
			break
		}
	}

	// If the task was found, we remove it from the slice.
	if index != -1 {
		// by default, we send the task to Assess
		t.RealmId = "1"
		t.EditTask()
		existingCollectionTasks = append(existingCollectionTasks.([]Task)[:index], existingCollectionTasks.([]Task)[index+1:]...)
	} else {
		// Task not found in the collection
		return ErrTaskByIdNotFound 
	}
	CollectionTasks.Set(c.Id, existingCollectionTasks)

	return nil
}

// getters

func GetAllCollections() (collections string, err error) {
	// implementation
} 

func GetCollectionById(collectionId string) (c Collection, err error) {
	// implementation
	if Collections.Size() != 0 {
		c, exist := Collections.Get(collectionId)
		if exist {
			// look for collection Tasks, Projects
			existingCollectionTasks, texist := CollectionTasks.Get(collectionId)
			if texist {
				c.(Collection).Tasks = existingCollectionTasks.([]Task)
			}
			existingCollectionProjects, pexist := CollectionProjects.Get(collectionId)
			if pexist {
				c.(Collection).Projects = existingCollectionProjects.([]Project)
			}
			return c.(Collection), nil
		} else {
			return nil, ErrCollectionByIdNotFound
		}
	}
}