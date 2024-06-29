// base implementation
package zentasktic

import (
	"time"

	"gno.land/p/demo/avl"
)


type Project struct {
	Id 			string `json:"projectId"`
	ContextId	string `json:"projectContextId"`
	RealmId 	string `json:"projectRealmId"`
	Tasks		[]Task `json:"projectTasks"`
	Body 		string `json:"projectBody"`
	Due			string `json:"ProjectDue"`
}

type ZProjectManager struct {
	Projects *avl.Tree // projectId -> Project
	ProjectTasks *avl.Tree // projectId -> []Task
}


func NewZProjectManager() *ZProjectManager {
	return &ZProjectManager{
		Projects: avl.NewTree(),
		ProjectTasks: avl.NewTree(),
	}
}

// actions

func (zpm *ZProjectManager) AddProject(p Project) (err error) {
	// implementation

	if zpm.Projects.Size() != 0 {
		_, exist := zpm.Projects.Get(p.Id)
		if exist {
			return ErrProjectIdAlreadyExists
		}
	}
	zpm.Projects.Set(p.Id, p)
	return nil
}

func (zpm *ZProjectManager) RemoveProject(p Project) (err error) {
	// implementation, remove from ProjectTasks too
	existingProject := Project{}

	if zpm.Projects.Size() != 0 {
		_, exist := zpm.Projects.Get(p.Id)
		if !exist {
			return ErrProjectIdNotFound
		}
	}
	
	// project is removable only in Asses (RealmId 1) or via a Collection (RealmId 4)
	if p.RealmId != "1" && p.RealmId != "4" {
		return ErrProjectNotRemovable
	}

	_, removed := zpm.Projects.Remove(existingProject.Id)
	if !removed {
		return ErrProjectNotRemoved
	}

	// manage project tasks, if any

	if zpm.ProjectTasks.Size() != 0 {
		_, exist := zpm.ProjectTasks.Get(existingProject.Id)
		if !exist {
			// if there's no record in ProjectTasks, we don't have to remove anything
			return nil
		} else {
			_, removed := zpm.ProjectTasks.Remove(existingProject.Id)
			if !removed {
				return ErrProjectTasksNotRemoved
			}
		}
	}

	return nil
}

func (zpm *ZProjectManager) EditProject(p Project) (err error) {
	// implementation, get project by Id and replace the object
	// this is for the project body and realm, project tasks are managed in the Tasks object
	existingProject := Project{}
	if zpm.Projects.Size() != 0 {
		_, exist := zpm.Projects.Get(p.Id)
		if !exist {
			return ErrProjectIdNotFound
		}
	}
	
	// project Body is editable only when project is in Assess, RealmId = "1"
	if p.RealmId != "1" {
		if p.Body != existingProject.Body {
			return ErrProjectNotInAssessRealm
		}
	}

	zpm.Projects.Set(p.Id, p)
	return nil
}

// helper function, we can achieve the same with EditProject() above
func (zpm *ZProjectManager) MoveProjectToRealm(p Project, realmId string) (err error) {
	// implementation
	if zpm.Projects.Size() != 0 {
		projectInterface, exist := zpm.Projects.Get(p.Id)
		if !exist {
			return ErrProjectIdNotFound
		}
		existingProject := projectInterface.(Project)
		existingProject.RealmId = realmId
		zpm.Projects.Set(p.Id, existingProject)
	}
	return nil
}

func (zpm *ZProjectManager) GetProjectTasks(p Project) (tasks []Task, err error) {
	// implementation, query ProjectTasks and return the []Tasks object
	var existingProjectTasks []Task

	if zpm.ProjectTasks.Size() != 0 {
		projectTasksInterface, exist := zpm.ProjectTasks.Get(p.Id)
		if !exist {
			return nil, ErrProjectTasksNotFound
		}
		existingProjectTasks = projectTasksInterface.([]Task)
		return existingProjectTasks, nil
	}
	return nil, nil
}

func (zpm *ZProjectManager) SetProjectDueDate(p Project, dueDate string) (err error) {

	// implementation
	// check if project exists
	projectInterface, exist := zpm.Projects.Get(p.Id)
	if !exist {
		return ErrProjectIdNotFound
	}
	existingProject := projectInterface.(Project)

	// check to see if project is in RealmId = 2 (Decide)
	if existingProject.RealmId == "2" {
		existingProject.Due = dueDate
		zpm.Projects.Set(p.Id, existingProject)
	} else {
		return ErrProjectNotEditable
	}

	return nil
}

// getters

func (zpm *ZProjectManager) GetProjectById(projectId string) (Project, error) {
	if zpm.Projects.Size() != 0 {
		pInterface, exist := zpm.Projects.Get(projectId)
		if exist {
			return pInterface.(Project), nil
		}
	}
	return Project{}, ErrProjectIdNotFound
}

func (zpm *ZProjectManager) GetAllProjects() (projects string, err error) {
	// implementation
	var allProjects []Project
	
	// Iterate over the Projects AVL tree to collect all Project objects.
	
	zpm.Projects.Iterate("", "", func(key string, value interface{}) bool {
		if project, ok := value.(Project); ok {
			// get project tasks, if any
			projectTasks, _ := zpm.GetProjectTasks(project)
			if projectTasks != nil {
				project.Tasks = projectTasks
			}
			allProjects = append(allProjects, project)
		}
		return false // Continue iteration until all nodes have been visited.
	})

	// Create a ProjectsObject with all collected tasks.
	projectsObject := ProjectsObject{
		Projects: allProjects,
	}

	// Use the custom MarshalJSON method to marshal the tasks into JSON.
	marshalledProjects, merr := projectsObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledProjects), nil
}

func (zpm *ZProjectManager) GetProjectsByRealm(realmId string) (projects string, err error) {
	// implementation
	var realmProjects []Project
	
	// Iterate over the Projects AVL tree to collect all Project objects.
	
	zpm.Projects.Iterate("", "", func(key string, value interface{}) bool {
		if project, ok := value.(Project); ok {
			if project.RealmId == realmId {
				// get project tasks, if any
				projectTasks, _ := zpm.GetProjectTasks(project)
				if projectTasks != nil {
					project.Tasks = projectTasks
				}
				realmProjects = append(realmProjects, project)
			}
		}
		return false // Continue iteration until all nodes have been visited.
	})

	// Create a ProjectsObject with all collected tasks.
	projectsObject := ProjectsObject{
		Projects: realmProjects,
	}

	// Use the custom MarshalJSON method to marshal the tasks into JSON.
	marshalledProjects, merr := projectsObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledProjects), nil
}

func (zpm *ZProjectManager) GetProjectsByContext(contextId string) (projects string, err error) {
	// implementation
	var contextProjects []Project
	
	// Iterate over the Projects AVL tree to collect all Project objects.
	
	zpm.Projects.Iterate("", "", func(key string, value interface{}) bool {
		if project, ok := value.(Project); ok {
			if project.ContextId == contextId {
				// get project tasks, if any
				projectTasks, _ := zpm.GetProjectTasks(project)
				if projectTasks != nil {
					project.Tasks = projectTasks
				}
				contextProjects = append(contextProjects, project)
			}
		}
		return false // Continue iteration until all nodes have been visited.
	})

	// Create a ProjectsObject with all collected tasks.
	projectsObject := ProjectsObject{
		Projects: contextProjects,
	}

	// Use the custom MarshalJSON method to marshal the tasks into JSON.
	marshalledProjects, merr := projectsObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledProjects), nil
}

func (zpm *ZProjectManager) GetProjectsByDate(projectDate string, filterType string) (projects string, err error) {
	// implementation
	parsedDate, err:= time.Parse("2006-01-02", projectDate)
	if err != nil {
		return "", ErrInvalidateDateFormat
	}

	var filteredProjects []Project
	
	zpm.Projects.Iterate("", "", func(key string, value interface{}) bool {
		project, ok := value.(Project)
		if !ok {
			return false // Skip this iteration and continue.
		}

		storedDate, serr := time.Parse("2006-01-02", project.Due)
		if serr != nil {
			// Skip projects with invalid dates.
			return false
		}

		switch filterType {
		case "specific":
			if storedDate.Format("2006-01-02") == parsedDate.Format("2006-01-02") {
				// get project tasks, if any
				projectTasks, _ := zpm.GetProjectTasks(project)
				if projectTasks != nil {
					project.Tasks = projectTasks
				}
				filteredProjects = append(filteredProjects, project)
			}
		case "before":
			if storedDate.Before(parsedDate) {
				// get project tasks, if any
				projectTasks, _ := zpm.GetProjectTasks(project)
				if projectTasks != nil {
					project.Tasks = projectTasks
				}
				filteredProjects = append(filteredProjects, project)
			}
		case "after":
			if storedDate.After(parsedDate) {
				// get project tasks, if any
				projectTasks, _ := zpm.GetProjectTasks(project)
				if projectTasks != nil {
					project.Tasks = projectTasks
				}
				filteredProjects = append(filteredProjects, project)
			}
		}

		return false // Continue iteration.
	})

	if len(filteredProjects) == 0 {
		return "", nil
	}

	// Create a ProjectsObject with all collected tasks.
	projectsObject := ProjectsObject{
		Projects: filteredProjects,
	}

	// Use the custom MarshalJSON method to marshal the tasks into JSON.
	marshalledProjects, merr := projectsObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledProjects), nil

}
