package zentasktic

import (
	"testing"

    "gno.land/p/demo/avl"
)

func Test_AddProject(t *testing.T) {
    
    project := Project{Id: "1", RealmId: "1", Body: "First project", ContextId: "1",}

    // Test adding a project successfully.
    err := project.AddProject()
    if err != nil {
        t.Errorf("Failed to add project: %v", err)
    }

    // Test adding a duplicate project.
    cerr := project.AddProject()
    if cerr != ErrProjectIdAlreadyExists {
        t.Errorf("Expected ErrProjectIdAlreadyExists, got %v", cerr)
    }
}


func Test_RemoveProject(t *testing.T) {
    
    project := Project{Id: "20", Body: "Removable project", RealmId: "1", ContextId: "2",}

    // Test adding a project successfully.
    err := project.AddProject()
    if err != nil {
        t.Errorf("Failed to add project: %v", err)
    }

    retrievedProject, rerr := GetProjectById(project.Id)
    if rerr != nil {
        t.Errorf("Could not retrieve the added project")
    }

    // Test removing a project
    terr := retrievedProject.RemoveProject()
    if terr != ErrProjectNotRemoved {
        t.Errorf("Expected ErrProjectNotRemoved, got %v", terr)
    }
}


func Test_EditProject(t *testing.T) {
    
    project := Project{Id: "2", Body: "Second project content", RealmId: "1", ContextId: "2",}

    // Test adding a project successfully.
    err := project.AddProject()
    if err != nil {
        t.Errorf("Failed to add project: %v", err)
    }

    // Test editing the project
    editedProject := Project{Id: project.Id, Body: "Edited project content", RealmId: project.RealmId, ContextId: "2",}
    cerr := editedProject.EditProject()
    if cerr != nil {
        t.Errorf("Failed to edit the project")
    }

    retrievedProject, _ := GetProjectById(editedProject.Id)
    if retrievedProject.Body != "Edited project content" {
        t.Errorf("Project was not edited")
    }
}


func Test_MoveProjectToRealm(t *testing.T) {
    
    project := Project{Id: "3", Body: "Project id 3 content", RealmId: "1", ContextId: "1",}

    // Test adding a project successfully.
    err := project.AddProject()
    if err != nil {
        t.Errorf("Failed to add project: %v", err)
    }

    // Test moving the project to another realm
    
    cerr := project.MoveProjectToRealm("2")
    if cerr != nil {
        t.Errorf("Failed to move project to another realm")
    }

    retrievedProject, _ := GetProjectById(project.Id)
    if retrievedProject.RealmId != "2" {
        t.Errorf("Project was moved to the wrong realm")
    }
}


func Test_GetAllProjects(t *testing.T) {
    
    // mocking the tasks based on previous tests
    // TODO: add isolation?
    knownProjects := []Project{
        {Id: "1", Body: "First project", RealmId: "1", ContextId: "1",},
        {Id: "10", Body: "Project 10", RealmId: "2", ContextId: "2",},
		{Id: "2", Body: "Edited project content", RealmId: "1", ContextId: "2",},
        {Id: "20", Body: "Removable project", RealmId: "1", ContextId: "2",},
        {Id: "21", Body: "Project 21", RealmId: "1",},
        {Id: "22", Body: "Project 22", RealmId: "1",},
		{Id: "3", Body: "Project id 3 content", RealmId: "2", ContextId: "1",},
    }

    // Manually marshal the known projects to create the expected outcome.
    projectsObject := ProjectsObject{Projects: knownProjects}
    expected, err := projectsObject.MarshalJSON()
    if err != nil {
        t.Fatalf("Failed to manually marshal known projects: %v", err)
    }

    // Execute GetAllProjects() to get the actual outcome.
    actual, err := GetAllProjects()
    if err != nil {
        t.Fatalf("GetAllProjects() failed with error: %v", err)
    }

    // Compare the expected and actual outcomes.
    if string(expected) != actual {
        t.Errorf("Expected and actual project JSON strings do not match.\nExpected: %s\nActual: %s", string(expected), actual)
    }
}

func Test_GetProjectTasks(t *testing.T){
    
    task := Task{Id: "1", RealmId: "1", Body: "First task", ContextId: "1",}

    project, perr := GetProjectById("1")
    if perr != nil {
        t.Errorf("GetProjectById() failed, %v", perr)
    }

    // test attaching to an existing project
    atterr := task.AttachTaskToProject(project)
    if atterr != nil {
        t.Errorf("AttachTaskToProject() failed, %v", atterr)
    }

    projectTasks, pterr := project.GetProjectTasks()
    if len(projectTasks) == 0 {
        t.Errorf("GetProjectTasks() failed, %v", pterr)
    }

    // test detaching from an existing project
    dtterr := task.DetachTaskFromProject(project)
    if dtterr != nil {
        t.Errorf("DetachTaskFromProject() failed, %v", dtterr)
    }

    projectWithNoTasks, pterr := project.GetProjectTasks()
    if len(projectWithNoTasks) != 0 {
        t.Errorf("GetProjectTasks() after detach failed, %v", pterr)
    }
}

func Test_GetProjectById(t *testing.T){
    // test getting a non-existing project
    nonProject, err := GetProjectById("0")
    if err != ErrProjectByIdNotFound {
        t.Fatalf("Expected ErrProjectByIdNotFound, got: %v", err)
    }

    // test getting the correct task by id
    correctProject, err := GetProjectById("1")
    if err != nil {
        t.Fatalf("Failed to get project by id, error: %v", err)
    }

    if correctProject.Body != "First project" {
        t.Fatalf("Got the wrong project, with body: %v", correctProject.Body)
    }
}

func Test_GetProjectsByRealm(t *testing.T) {
    
    // mocking the projects based on previous tests
    // TODO: add isolation?
    projectsInAssessRealm := []Project{
        {Id: "1", Body: "First project", RealmId: "1", ContextId: "1",},
		{Id: "2", Body: "Edited project content", RealmId: "1", ContextId: "2",},
        {Id: "20", Body: "Removable project", RealmId: "1", ContextId: "2",},
        {Id: "21", Body: "Project 21", RealmId: "1",},
        {Id: "22", Body: "Project 22", RealmId: "1",},
    }

    // Manually marshal the known projects to create the expected outcome.
    projectsObjectAssess := ProjectsObject{Projects: projectsInAssessRealm}
    expected, err := projectsObjectAssess.MarshalJSON()
    if err != nil {
        t.Fatalf("Failed to manually marshal projects in Assess: %v", err)
    }

    actual, err := GetProjectsByRealm("1")
    if err != nil {
        t.Fatalf("GetProjectByRealm('1') failed with error: %v", err)
    }

    // Compare the expected and actual outcomes.
    if string(expected) != actual {
        t.Errorf("Expected and actual projects JSON strings do not match.\nExpected: %s\nActual: %s", string(expected), actual)
    }
}

func Test_GetProjectsByContext(t *testing.T) {
    
    // mocking the projects based on previous tests
    // TODO: add isolation?
    projectsInContextOne := []Project{
        {Id: "1", Body: "First project", RealmId: "1", ContextId: "1",},
		{Id: "3", Body: "Project id 3 content", RealmId: "2", ContextId: "1",},
    }

    // Manually marshal the known tasks to create the expected outcome.
    projectsObjectForContexts := ProjectsObject{Projects: projectsInContextOne}
    expected, err := projectsObjectForContexts.MarshalJSON()
    if err != nil {
        t.Fatalf("Failed to manually marshal projects for ContextId 1: %v", err)
    }

    actual, err := GetProjectsByContext("1")
    if err != nil {
        t.Fatalf("GetProjectsByContext('1') failed with error: %v", err)
    }

    // Compare the expected and actual outcomes.
    if string(expected) != actual {
        t.Errorf("Expected and actual project JSON strings do not match.\nExpected: %s\nActual: %s", string(expected), actual)
    }
}

