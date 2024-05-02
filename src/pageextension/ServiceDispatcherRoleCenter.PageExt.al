pageextension 80108 "Service Dispatcher Role Center" extends "Service Dispatcher Role Center"
{
    layout
    {
        modify(Control18)
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