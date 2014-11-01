// testw32.cpp : Defines the entry point for the application.
//

#include "stdafx.h"
#include "testw32.h"
#include <iostream>
#define MAX_LOADSTRING 100

// Global Variables:
HINSTANCE hInst;								// current instance
TCHAR szTitle[MAX_LOADSTRING];					// The title bar text
TCHAR szWindowClass[MAX_LOADSTRING];			// the main window class name
BOOL bGO = true;
UINT TimerId;
int gPos = 1;
HWND g_hWindow = NULL;

static void mouseLeftMove(HWND hWindow, const int x, const int y);
static void mouseLeftClick(HWND hWindow, const int x, const int y);
static int gogo();

// Forward declarations of functions included in this code module:
ATOM				MyRegisterClass(HINSTANCE hInstance);
BOOL				InitInstance(HINSTANCE, int);
LRESULT CALLBACK	WndProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	About(HWND, UINT, WPARAM, LPARAM);

VOID CALLBACK TimerProc(HWND hWnd, UINT nMsg, UINT nIDEvent, DWORD dwTime) {	
	if (bGO) gogo();

	TCHAR szTemp[256] = {0};
	sprintf_s(szTemp, 256, "dwTime: %u", dwTime);
	OutputDebugStringA(szTemp);

	if (dwTime > 5000)
	{
		//KillTimer(NULL, TimerId);
	}
	
}

int APIENTRY _tWinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPTSTR    lpCmdLine,
                     int       nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);

 	// TODO: Place code here.
	MSG msg;
	HACCEL hAccelTable;

	// Initialize global strings
	LoadString(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
	LoadString(hInstance, IDC_TESTW32, szWindowClass, MAX_LOADSTRING);
	MyRegisterClass(hInstance);

	// Perform application initialization:
	if (!InitInstance (hInstance, nCmdShow))
	{
		return FALSE;
	}

	hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_TESTW32));

	// Main message loop:
	while (GetMessage(&msg, NULL, 0, 0))
	{
		if (!TranslateAccelerator(msg.hwnd, hAccelTable, &msg))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}

	KillTimer(NULL, TimerId);

	return (int) msg.wParam;
}



//
//  FUNCTION: MyRegisterClass()
//
//  PURPOSE: Registers the window class.
//
//  COMMENTS:
//
//    This function and its usage are only necessary if you want this code
//    to be compatible with Win32 systems prior to the 'RegisterClassEx'
//    function that was added to Windows 95. It is important to call this function
//    so that the application will get 'well formed' small icons associated
//    with it.
//
ATOM MyRegisterClass(HINSTANCE hInstance)
{
	WNDCLASSEX wcex;

	wcex.cbSize = sizeof(WNDCLASSEX);

	wcex.style			= CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc	= WndProc;
	wcex.cbClsExtra		= 0;
	wcex.cbWndExtra		= 0;
	wcex.hInstance		= hInstance;
	wcex.hIcon			= LoadIcon(hInstance, MAKEINTRESOURCE(IDI_TESTW32));
	wcex.hCursor		= LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground	= (HBRUSH)(COLOR_WINDOW+1);
	wcex.lpszMenuName	= MAKEINTRESOURCE(IDC_TESTW32);
	wcex.lpszClassName	= szWindowClass;
	wcex.hIconSm		= LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_SMALL));

	return RegisterClassEx(&wcex);
}

//
//   FUNCTION: InitInstance(HINSTANCE, int)
//
//   PURPOSE: Saves instance handle and creates main window
//
//   COMMENTS:
//
//        In this function, we save the instance handle in a global variable and
//        create and display the main program window.
//
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
   HWND hWnd;

   hInst = hInstance; // Store instance handle in our global variable

   hWnd = CreateWindow(szWindowClass, "自动砍红袋", WS_OVERLAPPEDWINDOW,
      CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, NULL, NULL, hInstance, NULL);

   if (!hWnd)
   {
      return FALSE;
   }

   ShowWindow(hWnd, nCmdShow);
   UpdateWindow(hWnd);

   return TRUE;
}

//
//  FUNCTION: WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the main window.
//
//  WM_COMMAND	- process the application menu
//  WM_PAINT	- Paint the main window
//  WM_DESTROY	- post a quit message and return
//
//
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	int wmId, wmEvent;
	PAINTSTRUCT ps;
	HDC hdc;

	switch (message)
	{
	case WM_COMMAND:
		wmId    = LOWORD(wParam);
		wmEvent = HIWORD(wParam);
		// Parse the menu selections:
		switch (wmId)
		{
		case IDM_ABOUT:
			DialogBox(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), hWnd, About);
			break;
		case IDM_EXIT:
			DestroyWindow(hWnd);
			break;
		default:
			return DefWindowProc(hWnd, message, wParam, lParam);
		}
		break;
	case WM_PAINT:
		hdc = BeginPaint(hWnd, &ps);
		// TODO: Add any drawing code here...
		EndPaint(hWnd, &ps);
		break;
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	case WM_KEYDOWN:
		switch (wParam)
		{
		case VK_CONTROL :
			g_hWindow = FindWindow(NULL, "2014天猫双11狂欢城-尚天猫，就购了 - Google Chrome");
			//KillTimer(NULL, TimerId);

			//TimerId = SetTimer(NULL, 0, 100, &TimerProc);
			//gPos = 1;
			gogo();			
			//bGO = bGO ? false : true;
			break;
		case VK_SHIFT :
			//KillTimer(NULL, TimerId);
			TimerId = SetTimer(NULL, 0, 100, &TimerProc);
			gPos = 2;
			gogo();			
			//bGO = bGO ? false : true;
			break;
		}
		break;
	
	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}

// Message handler for about box.
INT_PTR CALLBACK About(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	switch (message)
	{
	case WM_INITDIALOG:
		return (INT_PTR)TRUE;

	case WM_COMMAND:
		if (LOWORD(wParam) == IDOK || LOWORD(wParam) == IDCANCEL)
		{
			gogo();
			EndDialog(hDlg, LOWORD(wParam));
			return (INT_PTR)TRUE;
		}
		break;
	}

	return (INT_PTR)FALSE;
}





int gogo()
{
	//HWND hWindow1 = FindWindow(NULL, "天猫tmall.com-上天猫，就购了 - Google Chrome");	

	HWND chrome_hwnd = FindWindowEx( NULL, NULL, "Chrome_WidgetWin_1", NULL );
	int len = GetWindowTextLength(chrome_hwnd) + 1;
	LPTSTR title = new TCHAR[len];
	//Verify that you are not out of memory here. Omitted for simplicity.
	GetWindowText(chrome_hwnd, title, len);
	OutputDebugStringA(title);

	if (0 == lstrcmp(title, _T("天猫tmall.com-上天猫，就购了 - Google Chrome"))) {
		OutputDebugStringA("done");
	} else {
		//DestroyWindow(chrome_hwnd);
		//SendMessage(chrome_hwnd, WM_CLOSE, NULL, NULL);		
		//SendMessage( chrome_hwnd, WM_KEYDOWN, VK_LCONTROL, 0 );
		//SendMessage( chrome_hwnd, WM_KEYDOWN, 0x57, 0 );
		//SendMessage( chrome_hwnd, WM_KEYUP, 0x57, 0 );
		//SendMessage( chrome_hwnd, WM_KEYUP, VK_LCONTROL, 0 );
		//SendMessage( chrome_hwnd, WM_KEYUP, 0x57, 0xc01d0001 );
		//SendMessage( chrome_hwnd, WM_KEYUP, VK_LCONTROL, 0xc0110001 );
		
		//PostMessage(chrome_hwnd, WM_CLOSE, NULL, NULL);// 整个窗口都关闭了

		PostMessage( chrome_hwnd, 0x0118, 0x0000FFFF, 0xBF8C391A);

		chrome_hwnd = FindWindowEx( chrome_hwnd, NULL, NULL, NULL );
		PostMessage( chrome_hwnd, WM_KEYDOWN, VK_LCONTROL, 0xc0110001);
		PostMessage( chrome_hwnd, WM_KEYDOWN, 0x57, 0xc01d0001 );
		PostMessage( chrome_hwnd, WM_KEYUP, 0x57, 0xc01d0001 );
		PostMessage( chrome_hwnd, WM_KEYUP, VK_LCONTROL, 0xc0110001 );
		PostMessage(chrome_hwnd, WM_DESTROY, NULL, NULL);

	}
	return 0;
	
	chrome_hwnd = FindWindowEx( chrome_hwnd, NULL, NULL, NULL );
	len = GetWindowTextLength(chrome_hwnd) + 1;
	LPTSTR title2 = new TCHAR[len];
	//Verify that you are not out of memory here. Omitted for simplicity.
	GetWindowText(chrome_hwnd, title2, len);
	OutputDebugStringA(title2);
	return 0;

	// find window
	//HWND hWindow = FindWindow(NULL, "天猫tmall.com-上天猫，就购了");
	//HWND hWindow = FindWindow(NULL, "天猫tmall.com-上天猫，就购了 - Google Chrome");	
	HWND hWindow = g_hWindow;

	if (NULL == hWindow) {
		KillTimer(NULL, TimerId);
		OutputDebugStringA("Couldn't find application.\n");
	}else{
		if (!SetForegroundWindow(hWindow)) {
			KillTimer(NULL, TimerId);
			OutputDebugStringA("Couldn't set application to foreground.");
		}else{
			// 最大化模式
			mouseLeftClick(hWindow, 555, 953);// 红包1
			Sleep(3500);
			mouseLeftClick(hWindow, 874, 446);// 关闭提示框1
			mouseLeftClick(hWindow, 877, 365);// 关闭提示框2
			mouseLeftClick(hWindow, 871, 440);// 关闭提示框3			
			mouseLeftClick(hWindow, 877, 444);// 关闭提示框4
			mouseLeftClick(hWindow, 880, 365);// 关闭提示框5
			OutputDebugStringA("红包1.");
			
			mouseLeftClick(hWindow, 628, 953);// 红包2
			mouseLeftClick(hWindow, 636, 953);// 红包2
			Sleep(3500);
			mouseLeftClick(hWindow, 874, 446);// 关闭提示框1
			mouseLeftClick(hWindow, 877, 365);// 关闭提示框2
			mouseLeftClick(hWindow, 871, 440);// 关闭提示框3
			mouseLeftClick(hWindow, 877, 444);// 关闭提示框4
			mouseLeftClick(hWindow, 880, 365);// 关闭提示框5
			OutputDebugStringA("红包2.");

			mouseLeftClick(hWindow, 707, 953);// 红包3
			Sleep(3500);
			mouseLeftClick(hWindow, 874, 446);// 关闭提示框1
			mouseLeftClick(hWindow, 877, 365);// 关闭提示框2
			mouseLeftClick(hWindow, 871, 440);// 关闭提示框3
			mouseLeftClick(hWindow, 877, 444);// 关闭提示框4
			mouseLeftClick(hWindow, 880, 365);// 关闭提示框5
			OutputDebugStringA("红包3.");

			Sleep(5000);
			HWND handle = GetForegroundWindow();
			int len = GetWindowTextLength(handle) + 1;
			LPTSTR title = new TCHAR[len];
			//Verify that you are not out of memory here. Omitted for simplicity.
			GetWindowText(handle, title, len);
			OutputDebugStringA(title);
			/*
			mouseLeftClick(hWindow, 587, 146);//close

			mouseLeftMove(hWindow, 563, 184);
			Sleep(20);
			mouseLeftMove(hWindow, 314, 375);
			Sleep(20);

			/*
			// 底部模式
			if( 1 == gPos) {
				mouseLeftClick(hWindow, 455, 186);//close

				mouseLeftMove(hWindow, 422, 202);
				Sleep(50);
				mouseLeftMove(hWindow, 194, 414);
				Sleep(50);
			} else {
				mouseLeftClick(hWindow, 948, 183);//close

				mouseLeftMove(hWindow, 893, 193);
				Sleep(50);
				mouseLeftMove(hWindow, 688, 402);
				Sleep(50);
			}
/*
			
			/*
			mouseLeftMove(hWindow, 517, 158);
			Sleep(50);			
			mouseLeftMove(hWindow, 394, 357);
			Sleep(50);

			mouseLeftMove(hWindow, 919, 158);
			Sleep(50);			
			mouseLeftMove(hWindow, 526, 357);
			Sleep(50);
			*/
		}
	}
	return 0;
}

void mouseLeftMove(HWND hWindow, const int x, const int y)
{ 
	// get the window position
	RECT rect;
	GetWindowRect(hWindow, &rect);

	// calculate scale factor
	const double XSCALEFACTOR = 65535 / (GetSystemMetrics(SM_CXSCREEN) - 1);
	const double YSCALEFACTOR = 65535 / (GetSystemMetrics(SM_CYSCREEN) - 1);

	// get current position
	POINT cursorPos;
	GetCursorPos(&cursorPos);
	double cx = cursorPos.x * XSCALEFACTOR;
	double cy = cursorPos.y * YSCALEFACTOR;

	// calculate target position relative to application
	double nx = (x + rect.left) * XSCALEFACTOR;
	double ny = (y + rect.top) * YSCALEFACTOR;

	INPUT Input={0};
	Input.type = INPUT_MOUSE;

	Input.mi.dx = (LONG)nx;
	Input.mi.dy = (LONG)ny;

	// set move cursor directly and left click
	//Input.mi.dwFlags = MOUSEEVENTF_MOVE | MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_LEFTUP;
	Input.mi.dwFlags = MOUSEEVENTF_MOVE | MOUSEEVENTF_ABSOLUTE;

	SendInput(1,&Input,sizeof(INPUT));
}

void mouseLeftClick(HWND hWindow, const int x, const int y)
{ 
	// get the window position
	RECT rect;
	GetWindowRect(hWindow, &rect);

	// calculate scale factor
	const double XSCALEFACTOR = 65535 / (GetSystemMetrics(SM_CXSCREEN) - 1);
	const double YSCALEFACTOR = 65535 / (GetSystemMetrics(SM_CYSCREEN) - 1);

	// get current position
	POINT cursorPos;
	GetCursorPos(&cursorPos);
	double cx = cursorPos.x * XSCALEFACTOR;
	double cy = cursorPos.y * YSCALEFACTOR;

	// calculate target position relative to application
	double nx = (x + rect.left) * XSCALEFACTOR;
	double ny = (y + rect.top) * YSCALEFACTOR;

	INPUT Input={0};
	Input.type = INPUT_MOUSE;

	Input.mi.dx = (LONG)nx;
	Input.mi.dy = (LONG)ny;

	// set move cursor directly and left click
	Input.mi.dwFlags = MOUSEEVENTF_MOVE | MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_LEFTUP;	

	SendInput(1,&Input,sizeof(INPUT));
}
