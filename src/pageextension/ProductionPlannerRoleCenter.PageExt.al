pageextension 80104 "Production Planner Role Center" extends "Production Planner Role Center"
{
    layout
    {
        modify(Control45)
        {
            Visible = false;
        }
        addfirst(rolecenter)
        {
            part(CustomHeadline; "Headline RC Custom")
            {
                ApplicationArea = All;
            }
        }
    }
}